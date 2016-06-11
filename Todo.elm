{--

1. ABOUT

A simple Todo List application for the following Dissertation Project for student 150033255.

The project source code can be located on Github @ ... for locating previous versions.

2. ARCHITECTURE

The Application has been broken down into three parts using the popular MVC pattern:

- Model (Series of methods to capture the current state of the 'world' within the application)
- Update (Some methods to bind and move the current state of the 'world' within the application forward)
- View (Some methods that accept the passed current state of the 'world' and visualise the state through HTML)

3. BUILD COMMANDS

Run the following terminal commands from the root of the 'src' folder:

'elm-make Todo.elm --output elm.js'

4. MODULES

In Elm, Modules are exposed and integrated into the program using the 'exposing' method.

Remember that it is important to make sure that Qualified imports are preferred. 
Module names must match their file name, so module Parser.Utils needs to be in file Parser/Utils.elm.
Modules can also be imported through using native library modules such as the 0.16.0 'Basics, Debug, List, Maybe, Result', and 'Signal'.
What is important to identify is that Elm uses two versions of importing modules : Qualified & Unqualified.

* Qualified Imports will import a full range of helper functions.
* UnQualified Imports will only import chosen helper functions to be used in different locations of the application state. 

--}


{--

0.0 SET UP MODULES 

With this in mind, we will be predominately using the following Modules:

1. Html (For creating and adding Html elements to DOM tree)
2. Html.App (Module for implementing a pattern for building Elm applications using the delegated Elm Architecture)
3. Html.Attributes (For adding Attributes and class types to created Html elements in the DOM tree)
4. Html.Events (For adding Event handlers to the created Html elements in the DOM tree)
5. Debug (For better Debugging information rendering to the compiler)
6. Html.Lazy (Rather than immediately applying functions to their arguments, module will bundle up arguments up for later)
7. Json.Decode (A package that will turn JSON strings and JS values into Elm values)
8. String (A String package will be used for manipulating String Literal data types)

--}
import Html exposing (Html, h1, button, div, text, input, label)
import Html.App as Todo
import Html.Attributes exposing(class, style, placeholder, type', id, autofocus, value, for)
import Html.Events exposing (onClick, onInput, on, keyCode, targetChecked, onCheck)
import Debug exposing (log)
import Json.Decode as Json
import String
{--

0.1 SET UP PROGRAM STRUCTURE

We have to begin by setting up a program structure for our application. 
Furthermore, we have to do this in order to apply the Elm architecture to our program and understand what it is we are 
going to show in our browser. Therefore, we can follow the Elm Docs and have a program that follows the following outline:

Main: =>
  model = model
  , view = view 
  , update = update

--}
main =
  Todo.beginnerProgram 
  { model = model 
  , view = view 
  , update = update 
  }
{--

0.2 SET UP Types

....

--}
type alias Task = {
  description: String
  , uid: Int -- Unique Identifier.
  , complete: Bool
}

type alias Model = {
  tasks: List Task
  , text: String
  , count: Int

}

type Msg
  = TaskDescription String
  | EnterButton Int
  | CompleteOrIncomplete Bool Int
  | CreateTodo
  | DeleteAll
  --| DeleteSelected
{--

1.0 SET UP MODEL COMPONENT

The state and structure of the application logic ::

1. Model -> Task -> Model
2. Model -> Model -> Model

--}
model : Model
model =
  { text = "", tasks = [], count= 1 }
{-- 

1.1 SET UP KEYBOARD COMMANDS

We assign a function 'onKeyUp' that sends a Elm 'msg' command. 

It passes 'enter' which we will use to describe the enter button.

This will eventually in the 'Update' section trigger the CreateTask function within the model state.

--}
onKeyUp : (Int -> msg) -> Html.Attribute msg
onKeyUp enter =
  on "keyup" (Json.map enter keyCode)
{-- 

2.0 SET UP UPDATE COMPONENT

The 'Update' section of the MVC acts as a general dispatch for the models actions.

Although, the update is not associated with the core components of an MVC pattern, in Elm and many other patterns, its role is crucial.

It's crucial because it listens to all of the models interactions (also known in Elm as 'Signals' or 'Cmd' Actions)

Actions take the current state of the model and yield a new model in turn, therefore the 'Update' is used for capturing new values from the Model.

Once any new values are captured, our actions are dispatched and the models state is subsequently updated.

--}
update: Msg -> Model -> Model
update action model = 
  case action |> log "action" of

    TaskDescription inputText ->
      { model 
        | text = inputText 
      }

    EnterButton code ->
      if code == 13 then -- We use the Int 13 because this represents the 'enter' keyboard number.
        createTask model
      else
        model

    CompleteOrIncomplete checked uid ->
      { model 
        | tasks = List.map (\task -> updateTask task uid checked) model.tasks 
      }

    CreateTodo ->
      createTask model

    DeleteAll ->
      { model 
      | tasks = []
      , count = 1
      }

-- Our Update Declarations:
createTask: Model -> Model
createTask model =
  if String.isEmpty model.text then
    model
  else
    { model 
        | count = model.count + 1 
        , text = ""
        , tasks = model.tasks ++ [ { description = model.text, uid = model.count, complete = False } ]
      }

updateTask: Task -> Int -> Bool -> Task
updateTask task uid checked = 
  if task.uid == uid then
    {
    task | complete = checked
    }
  else
    task
      
{--

3.0 SET UP VIEW COMPONENT

What is the 'View'? 

The 'View' is derived at all times from the state of the model. 

Essentially, think about it in a way of visualising the state of the world, i.e the context of the world. 

Say we had an initial state of the world that represents a full cup of coffee.

Init => Full Cup => Capture Full Cup => Display in the 'View' a full cup of coffee.

State change => Half Cup => Capture Half Cup => Display in the 'View' half a cup of coffee.
State change => Empty Cup => Capture the Empty Cup => Display in the 'View' an empty cup of coffee.
State changes could be someone drinking from the same cup, such as a user adding a new task. So it proposes a uidber of questions.

How do we intend to visulaise in the DOM our state of the world (tasks) in HTML?

Well, the 'View' component lets us do just that.

--}
view : Model -> Html Msg 
view model =
  div []
    [ -- Begin Parent 'div'.
     div [id "header"] -- Begin Header inside Parent 'div'.
      [ h1 [] [text "Enter a Todo!"] ]
      , input -- Begin Input area for Todo Tasks inside Parent 'div'.
        [ 
        type' "text"
          , placeholder "Add a task" 
          , onInput TaskDescription, autofocus True
          , value model.text
          , onKeyUp EnterButton
        ] [] -- End Input area for Todo Tasks inside Parent 'div'.
        , div -- Begin Container for task lists inside Parent 'div'.
        [id "tasks-holder"] (List.map taskHtml  (model.tasks))  
        , div -- Begin Container for buttons inside Parent 'div'.
        [class "button-group"] 
        [
         button -- Begin HTML for Buttons inside Button Container.
         [ type' "button" , class "success addTask button", onClick CreateTodo] 
         [ text "Add Task" ]
         , button 
         [type' "button", class "alert clearAll button", onClick DeleteAll] 
         [ text "Clear Task" ]
         , button 
         [type' "button", class "alert clearSelected button", onClick DeleteAll] 
         [ text "Clear All" ]
        ] -- End HTML for Buttons inside Button Container.
    ] -- End Parent 'div'.
taskHtml: Task -> Html Msg -- Begin View for each individual Task Todo to be displayed inside Main View of Model. 
taskHtml task =
  div [class "row"] [
    div [class "small-12 columns"] [
      input [ 
        type' "checkbox"
        , id ("checkbox_" ++ toString task.uid)
        , onCheck (\bool -> CompleteOrIncomplete bool task.uid)
      ]
      [],
      label [ 
        for ("checkbox_" ++ toString task.uid), 
        class (if task.complete then "completed" else "") -- If task is checked, then if complete is true, add the class "completed".
        ] 
      [text task.description]
    ]
  ]
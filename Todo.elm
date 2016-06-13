{--

* ABOUT Application *

A simple Todo List Application for the following Dissertation Project for student 150033255.

Also, the application has been created in order to explore and learn more about the Elm Language.

NOTE: See 'elm-package.json' for more information.

* ARCHITECTURE *

The Application has been broken down into three parts using the popular MVC pattern:

- Model (Series of methods to capture the current state of the 'world' within the application.)
- Update (Some methods to bind and move the current state of the 'world' within the application forward.)
- View (Some methods that accept the passed current state of the 'world' and visualise the state through HTML.)
- Init (A model state declaration for the model to display on page load.)
- Subscriptions (Any interactions that the model and program can not foresee, can be added and tracked using Subscriptions.)

* BUILD COMMANDS *

Run the following terminal commands from the root of the 'src' folder:

'elm-make Todo2.elm --output Todo2.js'

* MODULES *

In Elm, Modules are exposed and integrated into the program using the 'exposing' method.

Remember that it is important to make sure that Qualified imports are preferred. 
Module names must match their file name, so module Parser.Utils needs to be in file Parser/Utils.elm.
Modules can also be imported through using native library modules such as the 0.16.0 'Basics, Debug, List, Maybe, Result', and 'Signal'.
What is important to identify is that Elm uses two versions of importing modules : Qualified & Unqualified.

* Qualified Imports will import a full range of helper functions.
* UnQualified Imports will only import chosen helper functions to be used in different locations of the application state. 

5. CONTROLS

(...)

--}

{--

0.0 SET UP MODULES 

With this in mind, we will be predominately using the following Modules:

1. Html (For creating and adding Html elements to DOM tree)
2. Html.App (Module for implementing a pattern for building Elm applications using the delegated Elm Architecture)
3. Html.Attributes (For adding Attributes and class types to created Html elements in the DOM tree)
4. Html.Events (For adding Event handlers to the created Html elements in the DOM tree)
5. Debug (For better Debugging information rendering to the compiler)
8. String (A String package will be used for manipulating String Literal data types)

--}

import Html exposing (Html, div, text, h1, input, button, form)
import Html.App
import Html.Attributes exposing (class, id, value, placeholder, autofocus, type')
import Html.Events exposing (onInput, onClick, onSubmit, on, keyCode)
import Debug exposing (log)
import String

{--

1.0 SET UP MODEL COMPONENT

We have to begin by setting up a program structure for our application. 
Furthermore, we have to do this in order to apply the Elm architecture to our program and understand what it is we are 
going to show in our browser. Therefore, we can follow the Elm Docs and have a program that follows the following outline:

main: =
  model = model
  {  init = init
    , view = view 
    , update = update
    , subscriptions = subscriptions
  }  

Below, we use 0.17 prefixing and use `Html.App.program =' to assign the subsequent model logic.

As we are not using any unique or special interactions (say some sort of server side interaction), we can declare subscriptions and init 
as the currently are. 

--}

-- Set up Subscriptions
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- Set up Init
init : (Model, Cmd Msg)
init =
  (initialModel, Cmd.none)

-- Set up main program controls
main =
  Html.App.program
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }

type alias Todo =
  { text: String
  , id: Int
  }

type alias Model =
  { todos : List Todo
  , textField : String
  }

initialModel : Model
initialModel =
  { todos = []
  , textField = ""
  }

-- Messages
type Msg
  = Add String
  | Editing String
  | Remove Int
  | EnterButton String Int -- Seems like Elm does not have a onSubmit handler outside of <form>.
  | DeleteAll

{-- 

1.0 SET UP UPDATE COMPONENT

The 'Update' section of the MVC acts as a general dispatch for the models actions.
Although, the update is not associated with the core components of an MVC pattern, in Elm and many other patterns, its role is crucial.
It's crucial because it listens to all of the models interactions (also known in Elm as 'Signals' or 'Cmd' Actions).
Messages (Msg or Actions in 0.16) take the current state of the model and yield a new model in turn, therefore the 'Update' is 
used for capturing new values from the Model. Once any new values are captured, our actions are dispatched and the models state is 
subsequently updated.

--}
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Editing text ->
      ( { model | textField = text } , Cmd.none)

    Remove id ->
    let 
        newModel =
          { model
          | todos = List.filter (\m -> m.id /= id) model.todos
          }
        
    in 
        (newModel, Cmd.none)

    Add description ->   
    let
        string = String.trim description
        uId = List.map (\x -> x.id) model.todos 
                |> List.maximum
                |> Maybe.withDefault 0 
        newTodo =
            { text = string
            , id = uId + 1
            }
        newModel =
            { model
            | todos = List.append model.todos [newTodo]
            , textField = ""
            }
    in
        (newModel, Cmd.none)

    EnterButton description code ->
    if code == 13
        then update (Add description) model
        else (model, Cmd.none)
    
    DeleteAll ->
    let 
        newModel =
          { model
          | todos = []
          , textField = ""
          }
        
    in 
        (newModel, Cmd.none)

{--

2.0 SET UP VIEW COMPONENT

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

-- View for the model state.
view : Model -> Html Msg
view model =
  div [id "header"]
    [ h1
        []
        [ text "Simple Todo Application:" ]
    , form 
        [ onSubmit (Add model.textField)
        , id "tasks-holder"
        ] 
        [ input
            [ value model.textField
            , placeholder "Enter New Todo!"
            , autofocus True
            , onInput (\s -> Editing s)
            , class "todo-input"
            ]
            []
        , button
            [ type' "submit"
            , class "success addTask button"
            ]
            [text "Add Todo" ]
            
        , button
            [ onClick (DeleteAll)
            , class "alert clearAll button" ]
            [text "Clear All" ]
        ]
    , div [ class "todo-list"] (todoList model)
    ]

-- View for the actual list container.
todoList : Model -> List (Html Msg)
todoList model =
  case model.todos of
    [] ->
      [ div [] 
        [ text "Please enter some tasks!" ] 
      ]
    todos ->
      List.map todoItem todos

-- View for a single Todo item.
todoItem : Todo -> Html Msg
todoItem todo =
  div [id "todo-item"]
    [ text todo.text
    , button
        [ onClick (Remove todo.id)
        , class "remove-todo button tiny"
        ]
        [ text "Remove" ]
    ]

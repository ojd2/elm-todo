{--

1. ABOUT

A simple Todo List application for the following Dissertation Project for student 150033255.

The project source code can be located on Github @ https://github.com/ojd2/FP_Elm_Todo for locating previous versions.

2. ARCHITECTURE

The Application has been broken down into three parts using the popular MVC pattern:

- Model (Series of methods to capture the current state of the 'world' within the application)
- Update (Some methods to bind and move the current state of the 'world' within the application forward)
- View (Some methods that accept the passed current state of the 'world' and visualise the state through HTML)

3. BUILD COMMANDS

Run the following terminal commands from the root of the src folder:

'elm-make Todo.elm --output elm.js'

4. MODULES

In Elm, Modules are exposed and integrated into the program using the 'exsposing' method.

Remember that it is important to make sure that Qualified imports are preferred. 

Module names must match their file name, so module Parser.Utils needs to be in file Parser/Utils.elm.

Modules can also be imported through using native library modules such as the 0.16.0 'Basics, Debug, List, Maybe, Result', and 'Signal'.

What is important to identify is that Elm uses two versions of importing modules : Qualified & Unqualified.

Qualified Imports will import a full range of helper functions.

UnQualified Imports will only import chosen helper functions to be used in different locations of the application state. 

--}

{--

0.0 SET UP MODULES

With this in mind, we will be predominatley using the following Modules:

1. Html (For creating and adding Html elements to DOM tree)
2. Html.Attributes (For adding Attributes and class types to created Html elements in the DOM tree)
3. Html.Events (For adding Event handlers to the created Html elements in the DOM tree)
4. Html.App (Module for implementing a pattern for building Elm applications using the delegated Elm Architecture)
5. Html.Lazy (Rather than immediately applying functions to their arguments, module will bundle up arguments up for later)
6. Json.Decode (A package that will turn JSON strings and JS values into Elm values)
7. String (A String package will be used for manipulating String Literal data types)

--}

import Html exposing (..)
import Html.App as App
import Html.Events exposing(..)
import Html.Attributes exposing(..)
import Html.Lazy exposing(lazy, lazy2)
import Json.Decode as Json
import String 

{--

0.1 SET UP PROGRAM

We have to begin by setting up a program structure for our application. 

Furthermore, we have to do this in order to apply the Elm architecture to our program and understand what it is we are 
going to show in our browser. Therefore, we can follow the Elm Docs and have a program that follows the following outline:

Main: =>
model = model
view = view 
update = update

--}

main : Program (Maybe Model) -- The 'Maybe' Model is used for representing values that may or may not exist.
main = 
        App.programWithFlags -- Same as 'program' but it lets you demand flags on initialization.
        { init = init
        , view = view
        , update = (\action model -> AddSetStorage (update msg model))
        , subscriptions = \_ Sub.none -- Similar to 'view' it is always applied to the latest model and captures any other external inputs within our model.
        }
{-- 

0.2 SET UP PORTS

Ports are used in order to ensure that any elm programs that communicate with JavaScript must do so in a coordinated and secure way.

Ports are declared in order to save the model on every update the model executes. 

In conjunction, the 'Cmd' type is used for specifying 1, what effects you need access to and 2, the type of messages that will come back into your application.

With this in mind, the ports act like a hole in the side of our program that can have a JavaScript source feed plugged into. 

What is nice about this is that it allows our program to declare JavaScript when we only need it.

Note: 'Cmd' also known as Commands are a way for Elm to detect any runtime objects that involve side effects.

These could be objects such as random numbers, random Http requests or saving Strings into local storage. 

--}

port SetStorage : Model -> Cmd action -- We want to use JavaScript for 'SetStorage' function.
port focus : String -> Cmd action -- We also want to use JavaScript for 'focus' that takes a String and stores the Cmd.

{--

0.3 STORE MODEL STATE ON EVERY UPDATE

We build a function here to store the model state on every update call. We have already declared the function above called 'AddSetStorage'.

Furthermore, we pass the Model and the Cmds and batch this together passing our 'SetStorage' function.

--}

AddSetStorage : (Model, Cmd Action) -> (Model, Cmd Action) 
AddSetStorage (model, cmds) =
        ( model, Cmd.batch [ SetStorage model, cmds ] )

{--

1.0 SET UP MODEL 

The state and structure of the application logic ::

1. Model -> Task -> Maybe Model
2. Model -> NewTask -> Maybe Model
3. Model -> EmptyTask -> Maybe Model

--}

type alias Model =
        { tasks = List Task -- 'List' is Elm's array constructor.
        , field = String
        , visibility = String
        , updatedId = String
       }
type alias Task =
        { description = String
        , visibility = String
        , id = Int
        , completed = Bool
        }
newTask : String -> Int -> Task
newTask = desc id = -- Passes both 'desc' & 'id' arguments and 'desc' is used to hold a new description.
        { description = desc
        , completed = False
        , editing = False
        , id = id
        }
emptyModel : Model 
emptyModel =
        { tasks = []
        , visibility = "All"
        , field = ""
        , updatedId = 0
        }
{--

1.1 SET UP MODEL ON INIT

Reasons for having an Init Model is for users to see the current state of the model on page load. 

Ideally, this means that on page load we can call our 'View' function with the initial model and render the state within our applications 'world'.

--}

init : Maybe Model -> (Model, Cmd Action)
init sateOfModel =
        -- A Maybe helps with optional arguments, error handling, and records with optional fields.
        -- Additionally, the withDefault method is used to substitute a default value, turning an optional value into a normal value.
        Maybe.withDefault emptyModel stateOfModel ! [] -- Here our emptyModel now points to stateOfModel which ! (overides) all [] (Lists).

{-- 

2.0 SET UP UPDATE

The 'Update' section of the MVC acts as a general dispatch for the models actions.

Although, the update is not associated with the core components of an MVC pattern, in Elm and many other patterns, its role is crucial.

It's curcial because it listens to all of the models interactions (also known in Elm as Signals or Cmd Actions)

Actions take the current state of the model and yield a new model in turn, therefore the 'Update' is used for capturing new values from the Model.

Once any new values are captured, our actions are dispatched and the models state is subsequently updated.

--}

type Action 
        = UpdateField String
        | AddTask
        | UpdateTask Int String
        | Delete Int
        | DeleteComplete
        | ChangeVisibility String

-- For any Action (in Elm => Msg) response in our Model state, recieve the response and then yield a model update.
update :: Action -> Model (Model, Cmd Action)
update action model =
        case action of
         NoOp -> -- It can be handy just to have a function that returns null. 
          model ! [] -- So incase an action happens where there are no actions manipulating the state, do nothing to the model. 

         AddTask -> -- However, if Adding a task is performed.
        { model
        | updatedId = model.updatedId + 1 -- For every task added, it's id is incremented.
        , field = "" -- The input field stores a String literal.
        , tasks =
                if String.isEmpty model.field then
                   model.tasks -- Conditional for if a task is empty it simply resides as an empty field.
                else
                   model.tasks ++ [newTask model.field model.updatedId] -- Else if task is added, the field value acquires the updated id.
        }
         ! []

        UpdateTask id taskAction ->
                let -- Let these values be...
                    updateTask t = 
                            if t.id = id then { t | description = taskAction } else t
                in -- In the following expression...
                   { model | tasks = List.map updateTask model.tasks }
        ! []

        UpdateField str ->
                { model | field = str }
        ! []
        
        DeleteComplete ->
                { model | tasks = List.filter (not  << .completed) model.tasks}
        ! []

        Delete id -> 
                model | tasks = List.filter (\t -> t.id /= id) model.tasks }

        ChangeVisibility visbility ->
                { model | visibility = visibility }
        ! [] -- Not sure if we need these?
{--

3.0 SET UP VIEW 

What is the 'View'? 

The 'View' is derived at all times from the state of the model. 

Essentially, think about it in a way of visualising the state of the world, i.e the context of the world. 

Say we had an initial state of the world that represents a full cup of coffee.

Init => Full Cup => Capture Full Cup => Display in the 'View' a full cup of coffee.

State change => Half Cup => Capture Half Cup => Display in the 'View' half a cup of coffee.

State change => Empty Cup => Capture the Empty Cup => Display in the 'View' an empty cup of coffee.

State changes could be someone drinking from the same cup, such as a user adding a new task. So it proposes a number of questions.

How do we intend to visulaise in the DOM our state of the world (tasks) in HTML?

Well, the 'View' component lets us do just that.

--}

view : Model -> Html Action
view model = 
        div 
         [ class "todomvc-wrapper"
         , style [  ("visibility", "hidden") ]
         ]
         [ section 
                [ id "todoapp" ] 
                [ lazy taskEntry model.field
                , lazy2 taskList model.visibility model.tasks
                ]
         ]

enterTask : String -> Html Action
enterTask task =
        taskInput
        [ id "taskInput" ]
        [ h1 [] [text "Todos"]
        , input
           [id "new-todo"
           , placeholder "What needs to be done?"
           , autofocus True
           , value task
           , name "TodoItem"
           , on "input" (Json.map UpdateField targetValue)
           , onEnter NoOp AddTask
           ]
           []
        ]
listTasks : String -> List Task -> Html Action
listTasks visibility tasks = 
        let 
            isVisible todo =
              case visibility of
                "Active Task" -> not todo.completed 
                _ -> True -- Let all tasks submitted have an active state.

            cssVisibility =
              if List.isEmpty tasks then "hidden" else "visible"
        in
           section
                [id "main" 
                , style [ ("Visibility", cssVisibility) ]
                ]
           [ input
           , ul 
           [ id "todo-list"]
           (List.map (taskItem) (List.filter isVisible tasks))
           []
           ]

taskItem : String -> Html Action
taskItem todo =
        li 
          [classList ["completed", todo.completed)]]
          [ div
            [class "view" ]
          [ input
            [class "select-todo"
            , type' "checkbox"
            , checked todo.completed
            , onClick (Check todo.id (not todo.completed))
            ]
            []
          , label 
            [ text todo.description ]
          , button
            [ class "delete-item"
            , onClick (Delete todo.id) 
            ]
            []
          ]
          , input 
            [ class "task-item"
            , value todo.description
            , name title
            ]
          []
        ]

controls : String -> List Task -> Html Action
controls visibility tasks =
        let 
            tasksCompleted = 
                    List.length (List.filter .completed tasks)
        in
           footer 
             [id "footer"
             , hidden (List.isEmpty tasks)
             ]
             [ button 
                [ class "clear-selected"
                , hidden (tasksCompleted==0) 
                , onClick DeleteComplete
                ]
             ]

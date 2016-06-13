import Html exposing (Html, div, text, h1, input, button)
import Html.Attributes exposing (value, placeholder)
import Html.Events exposing (onInput, onClick, onSubmit)
import Html.App
import String
import Debug exposing (log)

-- Model
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
  | EnterButton List String Int

-- Update
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

    EnterButton todos text code ->
    let
        newTodos = 
            if code == 13 then ("New todo added:" :: model.todos) 
            else model.todos
    in
        ({ model | todos = newTodos }, Cmd.none)

-- Subscriptions
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- Init
init : (Model, Cmd Msg)
init =
  (initialModel, Cmd.none)

-- Main
main =
  Html.App.program
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }

-- View
view : Model -> Html Msg
view model =
  div []
    [ h1
        []
        [ text "Simple Todo Application" ]
    , div []
        [ input
            [ value model.textField
            , placeholder "Enter new Todo"
            , onInput (\s -> Editing s)
            ]
            []
        , button
            [ onClick (Add model.textField) ]
            [ text "Add todo item." ]
        ]
    , div [] (todoList model)
    ]

todoList : Model -> List (Html Msg)
todoList model =
  case model.todos of
    [] ->
      [ div [] [ text "Please enter some tasks!" ] ]

    todos ->
      List.map todoItem todos


todoItem : Todo -> Html Msg
todoItem todo =
  div []
    [ text todo.text
    , button
        [ onClick (Remove todo.id)]
        [ text "Remove" ]
    ]
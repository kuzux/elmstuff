module Translate exposing (..)


type Language = English 
  | Turkish 
  | French
  | Swedish
  | Esperanto

type AppString = 
    Open
  | Closed
  | Doing
  | Wontfix
  | UniqueIssueError
  | IssueIdError
  | PageNotFound
  | FilterLabel
  | IssueNameLabel
  | NewIssueLabel
  | IssueText Int String

currLanguage : Language
currLanguage = English

untranslate : Language -> String -> AppString
untranslate lang str =
  case lang of
    English ->
      case str of 
        "Open" -> Open
        "Closed" -> Closed
        "Doing" -> Doing
        "Wontfix" -> Wontfix
        _ -> Open -- should never happen
    Turkish ->
      case str of
        "Açık" -> Open
        "Kapalı" -> Closed
        "Yapılıyor" -> Doing
        "Çözüm Yok" -> Wontfix
        _ -> Open
    _ -> Open

translate : Language -> AppString -> String
translate lang str =
  case lang of
    English ->
      case str of
        Open -> "Open"
        Closed -> "Closed"
        Doing -> "Doing"
        Wontfix -> "Wontfix"
        UniqueIssueError -> "An issue with the same name exists."
        IssueIdError -> "No issue with that id."
        PageNotFound -> "Page not found"
        FilterLabel -> "Filter: "
        IssueNameLabel -> "Issue Name: "
        NewIssueLabel -> "New Issue"
        IssueText id name ->
          "#" ++ (toString id) ++ ": " ++ name
    Turkish ->
      -- A bit humorous to translate 'issue' as 'mevzu'
      -- not an auto-translation error. it is intentional
      case str of
        Open -> "Açık"
        Closed -> "Kapalı"
        Doing -> "Yapılıyor"
        Wontfix -> "Çözüm Yok"
        UniqueIssueError -> "Bu adlı bir mevzu var."
        IssueIdError -> "Bu id'de bir mevzu yok."
        PageNotFound -> "Sayfa bulunamadi"
        FilterLabel -> "Filtre: "
        IssueNameLabel -> "Mevzu Adı: "
        NewIssueLabel -> "Mevzu Ekle"
        IssueText id name ->
          "#" ++ (toString id) ++ ": " ++ name
    French ->
      case str of 
        _ -> "PAS DE TRADUCTION"
    Swedish -> 
      case str of 
        _ -> "INGEN ÖVERSÄTTNING"
    Esperanto ->
      case str of
        _ -> "NENIA TRADUKO"

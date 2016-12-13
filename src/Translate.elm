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
      -- not an auto-translation error. It is intentional
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
        Open -> "Ouverte"
        Closed -> "Fermée"
        Doing -> "Faisant"
        Wontfix -> "Pas de Solution"
        UniqueIssueError -> "C'est déjá une problème avec ce nom."
        IssueIdError -> "Pas de problème avec cet id."
        PageNotFound -> "La page n'est pas trouvé"
        FilterLabel -> "Filtre: "
        IssueNameLabel -> "Nom de problème"
        NewIssueLabel -> "Ajouter problème"
        IssueText id name ->
          "#" ++ (toString id) ++ " : " ++ name
    Swedish -> 
      case str of 
        Open -> "Öppet"
        Closed -> "Stängd"
        Doing -> "Görande"
        Wontfix -> "Ingen Lösning"
        UniqueIssueError -> "Det finns redan ett problem med det namnet"
        IssueIdError -> "Inget problem med det id-numret"
        PageNotFound -> "Sidan är inte hittades"
        FilterLabel -> "Filter: "
        IssueNameLabel -> "Problemsnamn: "
        NewIssueLabel -> "Skapa problem"
        IssueText id name ->
          "#" ++ (toString id) ++ ": " ++ name
    Esperanto ->
      case str of
        Open -> "Malfermita"
        Closed -> "Fermita"
        Doing -> "Farata"
        Wontfix -> "Nenia Solvo"
        _ -> "NENIA TRADUKO"

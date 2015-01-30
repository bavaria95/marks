# marks
student's personal page with marks from google spreadsheet, implemented in Sinatra with SQLite

Stworzyć aplikację Rack lub Sinatra o następującej funkcjonalności:

Dostęp ma być możliwy po uprzednim zalogowaniu się

Loginy i skrót hasła (MD5, SHA*, ...) są przechowywane w bazie danych SQLite

Osoba która nie ma konta, może zarejestrować się poprzez formularz rejestracji

W trakcie rejestracji sprawdzana jest poprawność wprowadzanych danych: czy login lub hasło nie są za krótkie, czy w bazie danych nie występuje już osoba o takim loginie, ...

Po zalogowaniu, aplikacja wyświetla oceny danej osoby ze wszystkich przedmiotów

Dla każdego przedmiotu aplikacja ma automatycznie wyliczać ocenę końcową (zaliczenie) - średnia arytmetyczna

Oceny są przechowywane w arkuszu kalkulacyjnym Google - dostęp do arkusza ma się odbywać za pomocą interfejsu dostarczanego przez gem google-drive-ruby

Każdy przedmiot to osobna zakładka w arkuszu kalkulacyjnym

Logowanie do arkusza ma się odbywać w oparciu o standard OAuth 2.0 tzn. w oparciu o token dostępu, a nie login i hasło - patrz przykłady "How to use" na stronie gema google-drive-ruby
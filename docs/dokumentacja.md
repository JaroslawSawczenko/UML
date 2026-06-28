# Flicker - dokumentacja projektu

**Polski** | [English](documentation.md)

Flicker to aplikacja webowa umożliwiająca przeglądanie informacji o filmach,
ich ocenianie oraz dodawanie recenzji. Inspiracją są serwisy Filmweb oraz IMDb,
które pozwalają użytkownikom oceniać i komentować produkcje filmowe.

## Spis treści

- [Funkcjonalność](#funkcjonalność)
- [Technologie](#technologie)
- [Budowa systemu](#budowa-systemu)
- [Komponenty systemu](#komponenty-systemu)
- [Struktura bazy danych](#struktura-bazy-danych)
- [Scenariusze przypadków użycia](#scenariusze-przypadków-użycia)

## Funkcjonalność

### Użytkownik

- przeglądanie listy filmów,
- wyszukiwanie filmów po tytule,
- filtrowanie po gatunku i roku produkcji,
- podgląd szczegółowych informacji o filmie,
- podgląd średniej oceny filmu,
- przeglądanie recenzji innych użytkowników,
- dodawanie własnych ocen i recenzji (po zalogowaniu).

### Administrator

- dodawanie nowych filmów,
- edycja informacji o filmie,
- usuwanie filmów,
- usuwanie recenzji,
- zarządzanie użytkownikami.

## Technologie

| Warstwa     | Stos technologiczny                    |
| ----------- | -------------------------------------- |
| Frontend    | React.js / Next.js, Axios, TailwindCSS |
| Backend     | FastAPI, SQLAlchemy, JWT               |
| Baza danych | PostgreSQL / MySQL                     |

## Budowa systemu

**Frontend** odpowiada za:

- wyświetlanie listy filmów,
- wyszukiwanie i filtrowanie,
- formularze logowania i rejestracji,
- dodawanie ocen i recenzji.

**Backend** odpowiada za:

- obsługę zapytań HTTP,
- autoryzację użytkowników (JWT),
- przetwarzanie danych,
- komunikację z bazą danych (SQLAlchemy).

**Baza danych** to relacyjna baza (PostgreSQL lub MySQL), w której przechowywane
są wszystkie dane aplikacji.

## Komponenty systemu

- **Strona główna** - lista filmów oraz wyszukiwarka.
- **Strona szczegółów filmu** - szczegóły filmu, średnia ocena, lista recenzji
  oraz możliwość dodania własnej oceny i recenzji.
- **System użytkowników** - rejestracja i logowanie.
- **Panel administratora** - dodawanie, edycja i usuwanie filmów, edycja
  recenzji, zarządzanie użytkownikami.
- **API** - endpointy do obsługi filmów, użytkowników oraz ocen i recenzji.
- **Baza danych** - przechowywanie danych systemu oraz relacji między
  użytkownikami, filmami i recenzjami.

## Struktura bazy danych

### Users

| Pole          | Typ     | Opis                          |
| ------------- | ------- | ----------------------------- |
| id            | Integer | klucz główny                  |
| username      | String  | nazwa użytkownika             |
| email         | String  | adres e-mail                  |
| password_hash | String  | zahaszowane hasło             |
| role          | String  | rola: `user` lub `admin`      |

### Movies

| Pole         | Typ     | Opis             |
| ------------ | ------- | ---------------- |
| id           | Integer | klucz główny     |
| title        | String  | tytuł filmu      |
| description  | Text    | opis fabuły      |
| release_year | Integer | rok produkcji    |
| genre        | String  | gatunek          |

### Ratings

| Pole     | Typ     | Opis                          |
| -------- | ------- | ----------------------------- |
| id       | Integer | klucz główny                  |
| user_id  | Integer | klucz obcy do `Users`         |
| movie_id | Integer | klucz obcy do `Movies`        |
| rating   | Integer | ocena w skali 1-10            |

### Reviews

| Pole       | Typ      | Opis                     |
| ---------- | -------- | ------------------------ |
| id         | Integer  | klucz główny             |
| user_id    | Integer  | klucz obcy do `Users`    |
| movie_id   | Integer  | klucz obcy do `Movies`   |
| content    | Text     | treść recenzji           |
| created_at | DateTime | data dodania             |

### Relacje

- jeden użytkownik może dodać wiele recenzji,
- jeden film może mieć wiele recenzji,
- jeden użytkownik może ocenić wiele filmów,
- jeden film może mieć wiele ocen.

## Scenariusze przypadków użycia

### 1. Dodawanie oceny i recenzji

**Aktor główny:** zalogowany użytkownik

**Warunki wstępne:**

- użytkownik posiada konto w systemie Flicker,
- użytkownik jest zalogowany (posiada ważny token JWT),
- użytkownik znajduje się na stronie szczegółów konkretnego filmu.

**Warunki końcowe:**

- ocena i recenzja są zapisane w bazie i powiązane z filmem oraz użytkownikiem,
- średnia ocena filmu zostaje automatycznie przeliczona,
- recenzja jest widoczna dla innych użytkowników.

**Scenariusz główny:**

1. Użytkownik wybiera opcję "Dodaj ocenę i recenzję".
2. System wyświetla formularz zawierający skalę ocen (1-10) oraz pole na treść recenzji.
3. Użytkownik wybiera ocenę liczbową.
4. Użytkownik wprowadza treść recenzji.
5. Użytkownik klika przycisk "Opublikuj".
6. System przesyła żądanie do API wraz z tokenem JWT (autoryzacja).
7. System weryfikuje poprawność danych (czy ocena mieści się w skali, czy treść nie jest pusta).
8. System zapisuje dane w tabelach `Ratings` oraz `Reviews`.
9. System przelicza średnią ocenę dla danego filmu.
10. System wyświetla komunikat o pomyślnym dodaniu opinii i odświeża widok szczegółów filmu.

**Scenariusze alternatywne:**

- *Sesja wygasła (nieprawidłowy token JWT):* system informuje o konieczności
  ponownego zalogowania i przekierowuje do formularza logowania.
- *Dane niekompletne:* system podświetla puste pola i blokuje wysyłkę formularza
  do czasu uzupełnienia danych.

### 2. Dodawanie nowych filmów

**Aktor główny:** administrator

**Warunki wstępne:**

- użytkownik jest zalogowany na konto z rolą `admin`,
- administrator znajduje się w panelu administracyjnym.

**Warunki końcowe:**

- nowy film zostaje dodany do tabeli `Movies`,
- film staje się dostępny do wyszukiwania i oceniania przez wszystkich użytkowników.

**Scenariusz główny:**

1. Administrator wybiera opcję "Dodaj nowy film".
2. System wyświetla formularz dodawania filmu.
3. Administrator wprowadza dane: tytuł, opis fabuły, rok produkcji oraz gatunek.
4. Administrator zatwierdza formularz przyciskiem "Zapisz film".
5. System sprawdza, czy film o takim tytule i roku produkcji już nie istnieje w bazie.
6. System waliduje poprawność typów danych (np. czy rok jest liczbą).
7. System tworzy nowy rekord w tabeli `Movies` (SQLAlchemy).
8. System wyświetla potwierdzenie utworzenia filmu w katalogu.

**Scenariusze alternatywne:**

- *Film już istnieje w bazie:* system wyświetla komunikat "Ten film znajduje się
  już w systemie" i oferuje przejście do edycji istniejącego filmu.
- *Błąd walidacji danych:* system informuje o błędnym formacie danych (np. rok
  produkcji z przyszłości) i prosi o poprawę przed zapisem.

### 3. Rejestracja i logowanie

**Aktor główny:** gość (niezalogowany użytkownik)

**Warunki wstępne:**

- brak (użytkownik posiada dostęp do internetu i przeglądarki).

**Warunki końcowe:**

- w przypadku rejestracji: utworzenie rekordu w tabeli `Users`,
- w przypadku logowania: wygenerowanie i przekazanie użytkownikowi tokena JWT.

**Scenariusz główny:**

1. Gość wybiera opcję "Zaloguj się" lub "Zarejestruj się".
2. W przypadku rejestracji:
   - użytkownik podaje `username`, `email` oraz `password`,
   - system haszuje hasło (`password_hash`),
   - system zapisuje użytkownika w bazie z domyślną rolą `user`.
3. W przypadku logowania:
   - użytkownik podaje dane logowania,
   - system weryfikuje dane z bazą,
   - system generuje token dostępu JWT.
4. System przekierowuje użytkownika na stronę główną z uprawnieniami
   zalogowanego użytkownika.

**Scenariusze alternatywne:**

- *Nieprawidłowe dane logowania:* system wyświetla komunikat o błędnym loginie
  lub haśle i blokuje dostęp do funkcji zastrzeżonych.

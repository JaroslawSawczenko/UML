# Flicker - projekt UML

**Polski** | [English](README.en.md)

Modelowanie aplikacji webowej do oceniania i recenzowania filmów (w stylu
Filmweb / IMDb). Repozytorium zawiera komplet diagramów UML wraz z edytowalnymi
źródłami PlantUML oraz dokumentację techniczną systemu.

**Stos technologiczny modelowanego systemu:** React.js / Next.js, FastAPI,
SQLAlchemy, JWT, PostgreSQL / MySQL.

## Zakres modelu

Projekt opisuje system z trzema rolami (gość, zalogowany użytkownik,
administrator), warstwową architekturą (frontend, API, baza danych) oraz
relacyjnym modelem danych obejmującym filmy, użytkowników, oceny i recenzje.
Pełny opis znajduje się w [docs/dokumentacja.md](docs/dokumentacja.md).

## Diagramy UML

### Diagram klas

Model danych: encje `Users`, `Movies`, `Ratings`, `Reviews` wraz z atrybutami,
metodami i licznościami relacji.

![Diagram klas](diagrams/diagram-klas.png)

### Diagram przypadków użycia

Funkcje systemu w podziale na aktorów. Zastosowano generalizację aktorów:
administrator dziedziczy uprawnienia zalogowanego użytkownika, a ten - gościa.

![Diagram przypadków użycia](diagrams/diagram-przypadkow-uzycia.png)

### Diagram aktywności

Przepływ dodawania oceny i recenzji z podziałem na tory odpowiedzialności
(użytkownik, frontend, backend, baza danych), z obsługą autoryzacji JWT,
walidacji formularza oraz ścieżek błędu.

![Diagram aktywności](diagrams/diagram-aktywnosci.png)

### Diagram sekwencji

Wymiana komunikatów podczas dodawania recenzji - od interakcji użytkownika,
przez weryfikację tokena JWT, po zapis w bazie i odpowiedź `201 Created`.

![Diagram sekwencji](diagrams/diagram-sekwencji.png)

### Diagram komponentów

Warstwowa budowa systemu: komponenty frontendu, moduły backendu (autoryzacja,
zarządzanie filmami, oceny i recenzje, dostęp do danych) oraz interfejsy między
warstwami.

![Diagram komponentów](diagrams/diagram-komponentow.png)

### Diagram wdrożenia

Architektura uruchomieniowa: urządzenie użytkownika, serwer aplikacyjny oraz
serwer bazy danych wraz z protokołami komunikacji.

![Diagram wdrożenia](diagrams/diagram-wdrozenia.png)

## Struktura repozytorium

```text
.
├── README.md                 # ten plik (wersja polska)
├── README.en.md              # wersja angielska
├── diagrams/                 # wyrenderowane diagramy (PNG)
├── src/                      # edytowalne źródła PlantUML (.puml)
└── docs/
    ├── dokumentacja.md       # dokumentacja techniczna
    └── Flicker.docx          # oryginalny dokument
```

## Generowanie diagramów

Diagramy są generowane ze źródeł PlantUML w katalogu [src/](src/).

Wymagania: Java (JRE) oraz `plantuml.jar` pobrany ze strony
[plantuml.com/download](https://plantuml.com/download) i umieszczony w katalogu
głównym repozytorium. Polecenie uruchamiamy z katalogu głównego repozytorium:

```bash
java -jar plantuml.jar -tpng -o ../diagrams src/*.puml
```

Bez instalacji: pliki `.puml` można też wkleić bezpośrednio do edytora online
[plantuml.com](https://www.plantuml.com/plantuml).

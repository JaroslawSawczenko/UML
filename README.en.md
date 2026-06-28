# Flicker - UML project

[Polski](README.md) | **English**

UML model of a web application for rating and reviewing movies (in the style of
Filmweb / IMDb). The repository contains a full set of UML diagrams together with
editable PlantUML sources and technical documentation of the system.

**Technology stack of the modeled system:** React.js / Next.js, FastAPI,
SQLAlchemy, JWT, PostgreSQL / MySQL.

## Scope of the model

The project describes a system with three roles (guest, logged-in user,
administrator), a layered architecture (frontend, API, database) and a relational
data model covering movies, users, ratings and reviews. The full description is in
[docs/documentation.md](docs/documentation.md).

## UML diagrams

Eight diagrams covering the requirements, structure, data, dynamics and
architecture of the system. Polish variants are in [diagrams/](diagrams/).

### Use case diagram

System features grouped by actor. Actor generalization is used: the administrator
inherits the logged-in user's permissions, and the logged-in user inherits the
guest's.

![Use case diagram](diagrams/en/diagram-przypadkow-uzycia.png)

### Class diagram

Object model: `Users`, `Movies`, `Ratings`, `Reviews` entities with their
attributes, methods and relationship multiplicities.

![Class diagram](diagrams/en/diagram-klas.png)

### Entity-Relationship Diagram (ERD)

Relational database model in crow's foot notation - primary keys (PK), foreign
keys (FK) and the multiplicities of the relationships between tables.

![ERD](diagrams/en/diagram-erd.png)

### State diagram

The lifecycle of a review: from draft, through publication and moderation, to
deletion.

![State diagram](diagrams/en/diagram-stanow.png)

### Activity diagram

The flow of adding a rating and a review, split into swimlanes (user, frontend,
backend, database), with JWT authorization, form validation and error paths.

![Activity diagram](diagrams/en/diagram-aktywnosci.png)

### Sequence diagram

Message exchange while adding a review - from the user interaction, through JWT
token verification, to the database write and the `201 Created` response.

![Sequence diagram](diagrams/en/diagram-sekwencji.png)

### Component diagram

Layered structure of the system: frontend components, backend modules
(authorization, movie management, ratings and reviews, data access) and the
interfaces between layers.

![Component diagram](diagrams/en/diagram-komponentow.png)

### Deployment diagram

Runtime architecture: the user's device, the application server and the database
server together with the communication protocols.

![Deployment diagram](diagrams/en/diagram-wdrozenia.png)

## Repository structure

```text
.
├── README.md                 # Polish version
├── README.en.md              # this file
├── LICENSE                   # MIT license
├── render.sh                 # regenerates all diagrams
├── diagrams/                 # rendered diagrams, Polish (PNG)
│   └── en/                   # English variants
├── src/                      # PlantUML sources (Polish)
│   └── en/                   # PlantUML sources (English)
├── docs/
│   ├── dokumentacja.md       # technical documentation (Polish)
│   ├── documentation.md      # technical documentation (English)
│   └── Flicker.docx          # original document
└── .github/workflows/        # CI: automatic diagram rendering
```

## Generating the diagrams

The diagrams are generated from the PlantUML sources in [src/](src/) and
[src/en/](src/en/). Requirements: Java (JRE) and `plantuml.jar` downloaded from
[plantuml.com/download](https://plantuml.com/download).

The simplest way (regenerates both the Polish and the English set):

```bash
./render.sh
```

Or manually, from the repository root:

```bash
java -jar plantuml.jar -tpng -o ../diagrams       src/*.puml
java -jar plantuml.jar -tpng -o ../../diagrams/en src/en/*.puml
```

No installation needed: the `.puml` files can also be pasted directly into the
online editor [plantuml.com](https://www.plantuml.com/plantuml).

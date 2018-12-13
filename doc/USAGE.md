# Utilizzo

## Classe Cartella

Impostando nella la carella contenitore l'attributo "Visualizzazione dei figli" = FacetDatatable
viene attivata la visualizzazione.

## Classe da cercare

Si presuppone che la cartella contenga solamente una classe di oggetti.

All'interno di parts/children/facetdatatable va creato un template con chiamandolo con
l'identificatore della classe.

Prendendo spunto dai template esistenti è possibile impostare quali attributi visualizzare
in ricerca e quali visualizzare nella datatable risultante.

## Sviluppi

Nel caso si volesse modificare gli handler è sufficiente estendere facetsearch.ini
configurando il proprio Handler. L'handler deve estendere l'interfaccia ITFacetSearch.
#import "../template.typ": *

= Konzept <konzept>


== Ereignisdefinition <sec:definition>

Ein Ereignis ist ein konkretes Geschehnis, das im Artikel explizit als stattgefunden oder als fest geplant berichtet wird. Maßgeblich ist allein die Darstellung im Artikel: Der Wahrheitsgehalt der berichteten Ereignisse wird nicht überprüft, da dies den Rahmen der Arbeit überschreiten würde. Als fest geplant gelten Ereignisse mit konkretem Termin. Bei Ankündigungen wird das angekündigte Geschehen erfasst, sofern es einen Termin hat. Ein Ereignis gilt als geplant (Attribut `status`, @tab:schema), wenn es zum Zeitpunkt der Veröffentlichung des Artikels in der Zukunft liegt, auch wenn es inzwischen eingetreten ist.

Einem Ereignis ist zwingend ein Zeitpunkt oder Zeitraum zugeordnet, wobei die Präzision variieren kann (z.~B. Tag, Monat, Jahr). Die Zeitangabe muss im Artikel selbst stehen, da nicht das Weltwissen des #acr("LLM") geprüft werden soll. Außerdem muss sie sich auf das Geschehen selbst beziehen und nicht nur auf seine Meldung, etwa eine Aussage („Russland hat das Kraftwerk beschädigt, sagte XY am Sonntag“) oder das Erscheinungsdatum des Artikels. Andernfalls würden erwähnte historische Ereignisse als aktuelle Ereignisse erfasst. Historische Ereignisse mit konkreter Zeitangabe gelten dagegen als Ereignisse. Relative Zeitangaben wie „am Sonntag“ oder „letzte Woche“ werden über das Erscheinungsdatum aufgelöst. Eine Zeitangabe gilt auch für die folgenden Sätze, solange diese erkennbar dieselbe Episode schildern. Folgt der Zeitpunkt nicht sicher aus dem Text, etwa bei „shortly after the invasion in 2022“, wird das Geschehen nicht erfasst.

Spekulative oder hypothetische Geschehnisse gelten nicht als Ereignis. Ebenfalls ausgeschlossen sind Zustände, andauernde Prozesse und Entwicklungen, Meinungen und Bewertungen sowie statistische Angaben. Äußerungen wie Aussagen, Interviews, Reden, Posts oder Stellungnahmen sind selbst keine Ereignisse. Gibt eine Äußerung jedoch ein Geschehnis wieder, wird dieses als Ereignis erfasst. Der Ausschluss ist eine Festlegung und lässt sich nicht trennscharf begründen. Äußerungen kommen in nahezu jedem Nachrichtenartikel vor, und ihr Nachrichtenwert liegt im Inhalt und nicht im Vorgang des Sprechens. Würden sie erfasst, bestünde ein großer Teil der extrahierten Ereignisse aus Aussagen. Treffen, Telefonate und Verhandlungen zwischen Akteuren werden dagegen als Ereignis erfasst, ebenso Äußerungen mit unmittelbarer Wirkung wie Einladungen, Anträge, Urteile, Rücktritte oder die Veröffentlichung eines Berichts.

Jedes Geschehen wird pro Artikel nur einmal erfasst, auch wenn es mehrfach erwähnt wird. Bei verschiedenen Zeitangaben wird die spezifischste gewählt. Ereignisse mit unterschiedlichen Hauptakteuren werden als getrennte Ereignisse betrachtet, auch wenn sie kausal zusammenhängen oder zeitgleich eintreten (z.~B. König Harald stirbt, Haakon wird König). Unmittelbare Wirkungen und Details gehören dagegen zum Geschehen selbst („ein Angriff tötet zwölf Menschen“ ist ein Ereignis). Artikel können Geschehen unterschiedlich fein darstellen. #cite(<Hovy2013>, form: "prose") unterscheiden dafür zwei Beziehungen :

/ Subevents: ein Teilschritt eines Ablaufs zur gleichen Zeit, am selben Ort und mit den selben Akteuren
/ Membership: mehreren gleichartigen Geschehen, die sich in Ort, Zeit oder Beteiligten unterscheide und zusammen als Menge berichtet werden können

Subevents werden mit dem übergeordneten Geschehen zusammengefasst (z.~B. die Ankunft eines Staatsgasts zu Beginn eines Gipfels). Ebenso gehören unmittelbare Wirkungen zum Geschehen selbst („ein Raketenangriff zerstört fünf Häuser und tötet zehn Menschen“ ist ein Ereignis). Handeln allerdings andere Akteure, wird es als ein Ereignis erfasst, auch wenn es kausal zusammenhängt oder zeitgleich eintritt (z.~B. König Harald stirbt, Haakon wird König).
Membership-Events werden einzeln betrachtet, wenn sie im Artikel einzeln genannt werden. Wahlen in 5 Ländern haben jeweils unterschiedliche Akteure, Abläufe und Ergebnisse. Werden sie nur aufgezählt ("zwei weitere Landtagswahlen") wird die Menge als ein Ereignis erfasst. Davon zu unterscheiden ist ein einzelnes Geschehen an mehreren Orten: Ein Taifun über vier Provinzen bleibt ein Ereignis, da es nur einen Taifun gibt.
== Ereignisschema

Aus der Definition folgt das Schema in @tab:schema, das Beispiel steht in @tab:schema-beispiel. Da alle Artikel Englisch sind, wird die Beschreibung ebenfalls auf Englisch erstellt um Übersetzungsfehler zu vermeiden. Außerdem sollte die Fähigkeit des #acr("LLM") Texte zu übersetzen, sollte nicht Bestandteil dieser Untersuchung sein.

Es wird nur das Datum eines Ereignisses gespeichert, im Falle eines Zeitraums das Startdatum. Dies reicht aus zur Sortierung und Gruppierung. Die Genauigkeit der Zeitangabe wird im Attribut `date_precision` angegeben. Teilweise geben Artikel nur den Monat oder das Jahr eines Ereignisses an. Ohne dieses Attribut könnte Ereignisse ohne Tagangabe nicht richtig erfasst werden, obwohl sie nach der Definition valide Ereignisse sind. Es wurde bewusst darauf verzichtet, die Zeitangabe weiter zu spezifizieren, beispielsweise mit Uhrzeit, da diese selten in Artikeln steht und auch nicht notwendig ist für die weitere Betrachtung.

Felder für die Akteure eines Ereignisses werden ebenfalls nicht benutzt, da dies die Annotation und Auswertung stark verkomplizieren würde. Akteure sollten direkt in dem Attribut `description` genannt werden. Die Gewichtung der Ereignisse erfolgt noch nicht in diesem Schritt, da sie gruppierte Ereignisse voraussetzt (@sec:gewichtung).

#figure(
  table(
    columns: (auto, auto, 1fr),
    align: (left, left, left),
    table.header([*Attribut*], [*Werte*], [*Bedeutung*]),
    [`description`], [Text (Englisch)], [Das Geschehnis in einem Satz],
    [`date`],
    [`JJJJ-MM-TT`],
    [Zeitpunkt bzw. Beginn des Zeitraums; nicht bekannte Teile werden mit der Präzision gekennzeichnet],

    [`date_precision`], [`day` | `month` | `year`], [Genauigkeit der Datumsangabe im Artikel],
    [`status`], [`occurred` | `planned`], [Stattgefunden oder fest geplant],
  ),
  caption: [Attribute eines Ereignisses],
) <tab:schema>

#figure(
  table(
    columns: (auto, 1fr),
    align: (left, left),
    table.header([*Attribut*], [*Wert*]),
    [`description`], [King Harald V of Norway dies in hospital.],
    [`date`], [`2026-08-28`],
    [`date_precision`], [`day`],
    [`status`], [`occurred`],
  ),
  caption: [Beispielereignis aus einem Artikel vom 01.09.2026 („died on Friday“)],
) <tab:schema-beispiel>

== Aufbau der Pipeline <sec:pipeline>

Nach der Vorbereitung (@sec:vorbereitung) wird nun ein Python-Skript aufgerufen, das pro Artikel einen #acr("LLM")-Aufruf durchführt. Ein Aufruf pro Artikel ist notwendig, da sich die relativen Zeitangaben nur mit dem Publikationsdatum dieses Artikels auflösen lassen und so jedes Ereignis direkt seinem Artikel zugeordnet wird. Die Eingabe beinhaltet das Publikationsdatum, Überschrift und den Inhalt des Artikels. Der Standardprompt enthält die Definition aus @sec:definition und keine Beispiele. Varianten werden in @sec:varianten besprochen.  Die Ausgabe geschieht mit einem definierten JSON-Schema (Structured Output), welches dann in die gewünschte CSV-Datei umgewandelt wird @sec:llm. Die Ausgabe wird als eine Zeile pro Ereignis mit Artikel-ID gespeichert..


== Gruppierung <sec:gruppierung>

// - Ziel: dieselben Ereignisse aus verschiedenen Artikeln zusammenfassen (z. B. Tod Harald V in mehreren Artikeln)
// - Kandidaten: nur Ereignisse in einem gemeinsamen Zeitfenster vergleichen (Datum ± n Tage)
// - Ansätze laut Exposé: Embeddings + Ähnlichkeitsschwelle; LLM entscheidet paarweise; Kombination
//   (Embeddings schlagen Kandidatenpaare vor, LLM verifiziert)
// - Offen: welcher Ansatz bzw. Vergleich, Schwellwert, Umgang mit unterschiedlicher Datumspräzision
// - Ergebnis je Gruppe: einheitliche Beschreibung (Grundlage für die Gewichtung), Anzahl der Artikel


== Gewichtung <sec:gewichtung>

Die Gewichtung soll die weltweite Bedeutung eines Ereignisses widerspiegeln. Dafür werden die gruppierten Ereignisse als Grundlage genutzt (@sec:gruppierung). Eingabe ist die Beschreibung der Gruppe, nicht der Artikeltext, weil die Bedeutung am Ereignis hängt und abhängig von der Berichterstattung ist.
Für die Gewichtung werden drei Varianten verwendet und am Ende verglichen:
/ Gruppengröße: die Anzahl der Artikel dient als einfache als Basis. Je mehr Artikel über ein Ereignis berichten, desto wichtiger ist es. Allerdings wird dies auch durch die Schwerpunkte des Guardians beeinflusst
/ Jev: Das Modell Jev von TypeSafe erhält die Beschreibung der Gruppe und die Skala als Fragetyp _Score_. Er liefert einen Score sowie eine Angabe der Konfidenz
/ Claude: Claude bewertet diesselbe Beschreibung mit derselben Skala wie Jev. Damit wird überprüft, ob ein allgemeines #acr("LLM") zu einem ähnlichen Ergebnis kommt wie das spezialisierte Modell.

Es wird eine 5 stufige Skala von Jev und Claude verwendet:
- lokal (0): wichtig für eine Stadt oder Region
- national (1): wichtig für ein Land
- regional (2): wichtig für einige Länder
- international (3): wichtig für viele Länder
- global (4): wichtig für die gesamte Welt, Ereignisse mit historischer Bedeutung

Die Skala hat bewusst fünf Stufen, damit jede Stufe eindeutig beschreibbar ist. Eine feinere Abstufung (z.~B. 10 Stufen) wäre nicht mehr eindeutig erklärbar. Der Score lässt das Sortieren der Ergebnisse zu. Ein Vortest mit 3 Ereignissen zeigte, dass Jev auch bei mehrmaligen Anfragen sehr ähnliche Ergebnisse liefert. Bei zwei von den drei Ereignissen lag die Abweichung bei +-0.03. Bei dem anderen ungewöhnlichen Ereignis (Ratte in Alberta gefunden) lag die Abweichung bei +- 0.14, allerdings mit einer Konfidenz von 0.0. Claude Haiku 5.5 schätzt den Wert direkt und streut deutlich stärker (etwa +- 0.3) @tab:vortest.




Als Evaluation wird das Wikipedia-Portal "Current events" vom September 2026 verwendet.

== Varianten <sec:varianten>

// - Extraktion: Modellwahl, Einstellungen (Reasoning), Prompt; optional Freitext vs. JSON-Schema
// - Gruppierung: Embeddings vs. LLM vs. Kombination
// - Gewichtung: Gruppengröße vs. Jev vs. Claude
// - Alle Extraktionsvarianten werden gegen dieselbe Referenzannotation ausgewertet
// - Offen: konkrete Modelle und Prompt-Varianten festlegen (nach Prototyp)


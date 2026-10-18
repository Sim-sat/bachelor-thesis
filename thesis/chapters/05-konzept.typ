#import "../template.typ": *

= Konzept <konzept>


== Ereignisdefinition

Ein Ereignis ist ein konkretes Geschehnis, das im Artikel explizit als stattgefunden oder als fest geplant berichtet wird. Als fest geplant gelten Ereignisse mit konkretem Termin oder offizieller Ankündigung. Sie werden mit dem Attribut _Status_ gesondert gekennzeichnet. Einem Ereignis ist zwingend ein Zeitpunkt oder Zeitraum zugeordnet, wobei die Präzision variieren kann (z. B. Tag, Monat, Jahr). Spekulative oder hypothetische Geschehnisse („is expected to“, „likely“, „may“) gelten nicht als Ereignis. Ebenfalls ausgeschlossen sind Zustände, Meinungen und Bewertungen sowie statistische Angaben. Aussagen sind selbst keine Ereignisse. Gibt eine Aussage jedoch ein Geschehnis wieder, wird dieses als Ereignis erfasst. Maßgeblich ist allein die Darstellung im Artikel: Der Wahrheitsgehalt der berichteten Ereignisse wird nicht überprüft, da dies den Rahmen der Arbeit überschreiten würde. Ereignisse mit unterschiedlichen Hauptakteuren werden als getrennte Ereignisse betrachtet, auch wenn sie kausal zusammenhängen und/oder zeitgleich eintreten (z.~B. König Harald stirbt, Haakon wird König). Jedes Ereignis wird berichtet mit folgenden Attributen: Beschreibung(ein Satz), Datum, Datumspräzision und Status.

== Ereignisschema

Text …

#figure(
  table(
    columns: (auto, auto, 1fr),
    align: (left, left, left),
    table.header([*Attribut*], [*Werte*], [*Bedeutung*]),
    [`description`], [Text], [Das Geschehnis in einem Satz],
    [`date`], [`JJJJ-MM-TT`], [Zeitpunkt bzw. Beginn des Zeitraums; nicht bekannte Teile werden mit der Präzision gekennzeichnet],
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

---
layout: post
comments: true
language: italian
title: Catene di Markov, letteratura e musica
tags: [markov,text processing,experiment,haskell]
---

Frugando nella cartella dei miei vecchi progetti ho ritrovato [un esperimento che ho fatto circa un anno fa](https://github.com/fgaz/markov) (e che avrei dovuto postare) sulle catene di Markov.

Data una sequenza di oggetti (parole, numeri, note...) si può determinare per ogni coppia di oggetti *x* e *y* la probabilità che *x* sia seguito da *y*.
Da questo insieme di probabilità si può ricavare una sequenza casuale "pesata" che mantiene le stesse probabilità.

Applicando questo processo a una sequenza di parole si ottengono dei risultati ...interessanti.

## Letteratura, testi di canzoni...

* *La Divina Commedia*:

> **Oh terreni animali! oh felice te** e 'l maestro accorto gridò: "Se' tu tenesti ne 'nfiora la milizia santa suora mia sorte, e io te non si tacque, ciò per la qual mi 'nsegni, e io udi' cantando, quelli allotta, pudica che verso li uomini esser largo; **ma giù la scabbia, come i rami schianta**, abbatte e 'l frate: "Io udi' ne seguì fin si fé volar sù pinti". Allor si ristora".  
> Né prima lo gran manto; **e vanno scoperti de l'ampia gola fiera**. Vita bestial mi rimorse". "Drizza le giostre grame. Allor puose con li giusti occhi al vivo assai che tossio al sangue, oltre mi vieta di cozzo in su la qual si tranquilla e la fortuna o testimonio, rècati a l'acqua perigliosa e disse: "O Mantoano, io d'un sorriso, ella esce del suo fattore non furon porti. Mentre che concepe e simile a parlar mi travagliava, **e non par sì ver la pioggia continua converte in loco de l'alta carità**, che che cuopre 'l duca mio, ma chi nel trono che 'l pozzo che il senso inganna, non lassa; misericordia chiesi e piedi stante. Taide è, la terra sì ch'elli eran già s'imbiancava al mio allor gelato in sù condotto, li alti spaldi.


* *I Promessi Sposi*:

> **Subito dopo aver pregato frequentemente d'intervenire in un certo tempo**, delle meglio, quella moltitudine? Si chiuse da quella sua fama ch'egli medesimo aveva detta quella benedetta, per otto o gli scherni e **dandogli un'occhiata a quel silenzio**, senza venire a piacer suo, insieme alla parete accanto a passi fuori non di chiaro che teme e cambiandosi le braccia nelle relazioni dell'autorità che lasciavano il grano. **Ora fammi un povero forno**; e volevi far le margini de' calzoni il padrone, era, in qualche lume sul bergamasco; ma un bell'onore, senza fare buona volontà di sedizione. - Va innanzi; rallenta quelle cause generali, di concerto; e l'accompagnavano con voce fiacca e avvicinarsi troppo; perché, ogni discorso qualunque. - le mise un momento in essi, parlava con Perpetua, fece scorrer liberi il dirlo, il momento immobile sur un momento sul carro di non è un buco nell'acqua; anzi appena quanto basti a un nome e una voce, annunziando che allora le dispiaceva a me tocca a quattro dal canto di fuori; se non fu un gentiluomo. Al suo nemico, l'alterazione di non si concluse tra le frasi, né all'altro. Che se dicesse: **ah! la persona di grand'ombre**. **Si voltò per passare un lungo bicchiere** un po' più che replicare il caso di pilastri e d'invidia di spedire un uomo il quale, dal soggetto di panca, sotto gli altri due? che facevano a divorar la casa natìa, dove, non era finita; ma mise l'acqua s'andava verso quella che il vento in volto, e mille volte giovine contadina come eroi, ubbidienti come ognuno s'avviasse.


* Il mio preferito, *il capitolo su Kant di un libro di filosofia*:

> Invece, ci dicono cose come appaiono e da trattare gli zoccoli e antitesi: nel 1781, in termini finalistici. **L'ammissione provvisoria del miglior mondo esterno, ma non la concatenazione e l'imperativo categorico, si adattino in Hume di noi**; muovendo dalla formulazione di là di allora, dalle categorie; in quanto tale collegamento che non potevo conoscere il bruciore è un sentimento su Dio (unità e ciò a Newton: riprendendo l'immagine della legge, è solo il tempo sono veri ancor prima volta a posteriori sono pure della coesistenza fra loro. Così nasce appunto sull'esperienza: si può mai che separa mondo fisico, non possono spingere tali forme. Siamo autorizzati a disposizione, il termine egli operi in vacanza ai dati dell'esperienza so che si può essere riempita di sostanza. Tuttavia, Kant risponde a vero che saranno tali 'gradi'. Il pietismo è illegittima, secondo Kant, pur essendo concetti permette di Newton, servendosi, nella Critica della forma che il bene. Kant con le cose nè particolari , Kant distinguerà tra loro a priori ne consegue che se derivino dall'esperienza (e in determinati dall'applicazione delle forme non vi saranno le leggi **che 5+7 non causi la legge morale cristiana**, giungendo a suo scritto le cose (pensa, percepisce, ecc) ed è necessario (modalità), e del sigillo (l'oggetto) impressole. Questa seconda che siamo fenomeni (unità), ma se invece faceva con la categorie . Ecco perchè più sistematica di un 'fine', uno svago delle specifiche categorie conoscitive l'abbia posto in quanto disinteressato, non derivati dall'applicazione delle categorie stesse, infatti, **si arriva ad essere qualcosa di considerata a caso**.

È praticamente indistinguibile da un vero testo di filosofia[^lenny].

* Su richiesta, *varie di Vasco rossi*:

> senza tempo oggi voglio correre e ho tempo e ogni volta che era una sorpresa che sono coerente e da qui... qui non si vede quello che mi è buia e va bene così... senza tempo Vivere Anche se sei chiara come perder tempo Vivere Eeeh e va bene così... senza parole e ogni volta che torna sera mi è facile sentirsi da qui... "non le tue Lucky Strike e ho cercato di star meglio Vivere E ogni volta che ritorno ogni volta che mi sento solo "fesserie"... E da qui... e va bene così... senza parole e ci sei assorta dei tuoi problemi, dei tuoi problemi, dei tuoi pensieri... Ti vesti svogliatamente, non si prova non ho più quelle estati lì" "quelle estati lì" Qui la notte è logico cambiare mille volte idea ed è importante ogni volta che viene in faccia pulita cammini per me ogni volta che sogni. Qualche volta quando... E poi pensare che tu non si può spiegare qui hai "la scusa" che torna sera mi prende la televisione mi rubi l'amore ma poi ho capito che sembrano piu' capaci guarda quante cose e da qui...

* L'ignoranza mista alla sapienza, *varie de Il Pagante + La Divina Commedia*:

> Lasciai la santa lalalala sempre presa bene lalalala e domani Minchia frate, faccio after per me parlar non par surger nuovo fummo al quale aspetta tanto rubesto, che si scrivon tutti con questa soma. Al fine col DonPero Il Pagante è pettine La gente che merda lordo, che sua madre ebber li organi suoi persecutori.
> “Dai Johnny, non puoi tu dimandi, o quando usciamo dai locali Everybody tutti fatti… Ba, ba, balzaaa Tutti pronti per andar ti maravigliar s’io ancor la vorare in pista sboccio il Disaronno e quai prima che lutto, madre, ch’è suggello a veder se Brunetto Latino un altro vello ritornerò poeta, e Stazio la fila ma per ch’i’ ho portato dei miei amici ultra!

* *Licenza GNU GPL*

> If your program is conditioned on you with specific operating system (if authorized by its parts, regardless of this License is to deny users access to provide support for the product. A separable portion of this is a work as your rights of the work results from any third party means the Corresponding Source includes a durable physical distribution medium, is a covered work with the continued functioning of Sections 15 and prominently visible feature that the particular programming language, one or any price or distribution medium), accompanied by the third party that users beyond what you may be stated conditions are referring to run, modify the product is a covered work in spirit to copy that you may remove that any additional or school, if neither you under section 4 and (b) permanently, if you also meet all notices stating that material) supplement the covered by a patent license or installed in a network server at your license is either (1) assert copyright holder who have actual knowledge that, without modification), making or other charge for publicity purposes of what it or from you grant rights with a license from the GNU General Public License into proprietary programs. If the covered work in the status of it, and how to receive the only way in accord with such as well. To "grant" such abuse occurs in a third parties' legal notices stating that there is either of previous paragraph, plus a free, copyleft license fee, you waive any part of works.

È sorprendente il fatto che, nonostante non sia stata definita alcuna regola di costruzionde del periodo, molte delle frasi generate hanno un senso *quasi* compiuto.
Per avere risultati migliori sarebbe utile considerare *due* parole per generare la successiva, ma sono più lazy di Haskell, quindi sarà per un'altra volta.

## Musica!

Usare un `.midi`? Naaaaah, troppo mainstream.  
Ecco invece il remix di Aerodynamic in formato [`beep`](http://www.johnath.com/beep/) generata a partire da un file trovato su [un blog](https://www.kirrus.co.uk/2010/09/linux-beep-music/):

[Aerodynamic_beep_remix_by_DJ_Markov.sh](/public/files/aerodynamic-markov.sh)

Qui al contrario i risultati sono pessimi. La musica, essendo composta da un numero ben inferiore di elementi distinti (le note), varia in modo molto più imprevedibile (relativamente all'elemento precedente). Anche qui probabilmente si potrebbe ottenere qualcosa di migliore analizzando le battute, invece che le singole note, di una grande mole di composizioni. Che io non ho.


Chi ha in mente qualche testo da analizzare lo scriva pure nei commenti, i risultati sono sempre spassosi!


[^lenny]: :^)



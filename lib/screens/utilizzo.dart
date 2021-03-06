import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utilizzo extends StatelessWidget {
  static const String routeName = "/utilizzo";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 192, 192, 192),
        ),
        title: Text(
          "Guida all'Utilizzo",
          style: TextStyle(
            color: Color.fromARGB(255, 192, 192, 192),
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 24, 37, 102),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            Center(
              child: Text(
                "Benvenuto nella pagina di\nGuida all'utilizzo !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "In questa pagina saranno mostrate tutte le funzionalità dell'applicazione attraverso semplici passaggi, illustrati con immagini!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "PERCORSI",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 24, 37, 102),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10.0,
                left: 10.0,
              ),
              child: Image(
                image: AssetImage("assets/images/guida/percorsi_guida.png"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Nella sezione Percorsi troverete dei tondi con all'interno la descrizione di un percorso, oltre al pulsante (che è stato evidenziato) con il quale potrete recarvi nella pagina di approfondimento del percorso selezionato.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10.0,
                left: 10.0,
              ),
              child: Image(
                image:
                    AssetImage("assets/images/guida/percorsiInfo_guida.jpeg"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Quindi vi ritroverete nella seguente schermata, che sarà inerente al percorso selezionato.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "VISITA BARBIANA",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 24, 37, 102),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10.0,
                left: 10.0,
              ),
              child: Image(
                image: AssetImage("assets/images/guida/formVisita_guida.jpg"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "In Visita Barbiana troverete un form da compilare (vedi immagine sopra), e un pulsante 'Verifica Disponibilità' (vedi immagine inferiore).",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10.0,
                left: 10.0,
              ),
              child: Image(
                image:
                    AssetImage("assets/images/guida/disponibilita_guida.jpg"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Con quest'ultimo vi potrete recare nella pagina del Calendario delle Disponibilità (vedi sotto).",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10.0,
                left: 10.0,
              ),
              child: Image(
                image: AssetImage("assets/images/guida/scegliData_guida.jpg"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Quindi sarà presente un pulsante con il quale aprirete un calendario da cui scegliere una data e verificarne lo stato.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10.0,
                left: 10.0,
              ),
              child: Image(
                image: AssetImage("assets/images/guida/datePicker_guida.jpeg"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "In seguito elencherò le possibili risposte dell'applicazione : ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "1 - La data è già stata prenotata da qualche gruppo.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10.0,
                left: 10.0,
              ),
              child: Image(
                image: AssetImage("assets/images/guida/prenotata_guida.jpg"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "2 - La data è disponibile per cui vengono mostrati gli orari disponibili.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10.0,
                left: 10.0,
              ),
              child: Image(
                image: AssetImage("assets/images/guida/orari_guida.jpg"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "3 - La data non è disponibile per cui viene consigliato di scegliere nuovamente.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10.0,
                left: 10.0,
              ),
              child: Image(
                image:
                    AssetImage("assets/images/guida/nonDisponibile_guida.jpg"),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "DISDICI VISITA",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 24, 37, 102),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "In Disdici Visita troverete un form da compilare per disdire la visita (vedi sotto).",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10.0,
                left: 10.0,
              ),
              child: Image(
                image: AssetImage("assets/images/guida/disdiciForm_guida.jpeg"),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "EVENTI",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 24, 37, 102),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10.0,
                left: 10.0,
              ),
              child: Image(
                image: AssetImage("assets/images/guida/eventi_guida.jpg"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Nella sezione Eventi troverete dei tondi con all'interno i dati principali dell'evento, oltre al pulsante (che è stato evidenziato) con il quale potrete recarvi nella pagina di approfondimento dell'evento selezionato.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10.0,
                left: 10.0,
              ),
              child: Image(
                image: AssetImage("assets/images/guida/eventoInfo_guida.jpeg"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Quindi vi ritroverete nella seguente schermata, che sarà inerente all'evento selezionato.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "STAMPA E CI HANNO SCRITTO",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 24, 37, 102),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10.0,
                left: 10.0,
              ),
              child: Image(
                image: AssetImage("assets/images/guida/SECHS_guida.jpg"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Nella sezione Stampa e Ci Hanno Scritto troverete dei tondi con all'interno i dati principali dell'articolo, oltre al pulsante (che è stato evidenziato) con il quale potrete recarvi nella pagina di approfondimento dell'articolo selezionato.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10.0,
                left: 10.0,
              ),
              child: Image(
                image: AssetImage("assets/images/guida/sechsInfo_guida.jpeg"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Quindi vi ritroverete nella seguente schermata, che sarà inerente all'articolo selezionato.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "FOTO E VIDEO",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 24, 37, 102),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10.0,
                left: 10.0,
              ),
              child: Image(
                image: AssetImage("assets/images/guida/media_guida.jpg"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Nella sezione Foto e Video troverete dei tondi con all'interno o un video o una foto insieme ai relativi dati, oltre al pulsante (che è stato evidenziato) con il quale potrete recarvi nella pagina di approfondimento della foto o del video selezionato.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10.0,
                left: 10.0,
              ),
              child: Image(
                image: AssetImage("assets/images/guida/mediaInfo_guida.jpeg"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Quindi vi ritroverete nella seguente schermata, che sarà inerente alla foto o al video selezionato.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "DIVENTA SOCIO",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 24, 37, 102),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10.0,
                left: 10.0,
              ),
              child: Image(
                image:
                    AssetImage("assets/images/guida/iscrizioneForm_guida.jpg"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "In Diventa Socio troverete un form da compilare per iscrivervi alla fondazione.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10.0,
                left: 10.0,
              ),
              child: Image(
                image: AssetImage("assets/images/guida/pagamento_guida.jpeg"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Una volta compilato e inviato il form verrete ridiretti alla pagina di pagamento, in cui troverete il pulsante per attivare il form del pagamento, compilandolo con i dati della carta. Infine, verrete ridiretti alla pagina di conferma dell'iscrizione.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "RINNOVA ISCRIZIONE",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 24, 37, 102),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "In Rinnova Iscrizione troverete un form da compilare per rinnovare l'iscrizione (vedi sotto).",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10.0,
                left: 10.0,
              ),
              child: Image(
                image: AssetImage("assets/images/guida/rinnovaForm_guida.jpeg"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Una volta compilato e confermato il form, si aprirà un popup con un form da compilare con i dati della carta.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "RECUPERO CREDENZIALI",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 24, 37, 102),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "In Recupero Credenziali troverete un form da compilare per recuperare le credenziali (vedi sotto), che verranno inviate via e-mail.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10.0,
                left: 10.0,
              ),
              child: Image(
                image:
                    AssetImage("assets/images/guida/recuperoForm_guida.jpeg"),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "CAMBIO PASSWORD",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 24, 37, 102),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "In Cambio Password troverete un form da compilare per recuperare le credenziali (vedi sotto), che verranno inviate via e-mail.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10.0,
                left: 10.0,
              ),
              child: Image(
                image: AssetImage("assets/images/guida/cambioForm_guida.jpeg"),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Divider(
              thickness: 2,
              color: Color.fromARGB(255, 24, 37, 102),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "In caso di ulteriori problemi o nel caso aveste idee o consigli per migliorare l'applicazione contattare la seguente email : theprogxy@gmail.com.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 24, 37, 102),
              ),
            ),
            SizedBox(
              height: 35,
            ),
          ],
        ),
      ),
    );
  }
}

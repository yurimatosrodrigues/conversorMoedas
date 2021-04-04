import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=4caaf509";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context)  {

    final realController = TextEditingController();
    final dolarController = TextEditingController();
    final euroController = TextEditingController();

    double dolar = 0;
    double euro = 0;

    void _realChanged(String text){
      double valor = double.parse(text);
      dolarController.text = (valor / dolar).toStringAsFixed(2);
      euroController.text = (valor / euro).toStringAsFixed(2);
    }

    void _dolarChanged(String text){
      double valor = double.parse(text);
      dolarController.text = (valor * dolar).toStringAsFixed(2);
      euroController.text = (valor * dolar / euro).toStringAsFixed(2);
    }

    void _euroChanged(String text){
      double valor = double.parse(text);
      dolarController.text = (valor * euro).toStringAsFixed(2);
      euroController.text = (valor * euro / dolar).toStringAsFixed(2);
    }

    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
                title: Text("Conversor de moedas",
                          style: TextStyle(color: Colors.black,
                                            fontSize: 25.00)
                            ),
                backgroundColor: Colors.amber,
                centerTitle: true),
      body: FutureBuilder<Map>(
              future: getDados(),
              builder: (context, snapshot){// Devolve o Widget
                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: Text("Carregando dados...",
                               style: TextStyle(color: Colors.red,
                                                fontSize: 25.00),
                               textAlign: TextAlign.center),
                      );
                    default:
                      if(snapshot.hasError){
                        return  Center(
                          child: Text("Erro ao carregar Dados...",
                                    style: TextStyle(color: Colors.red,
                                    fontSize: 25.00),
                                  textAlign: TextAlign.center),
                        );
                      }
                      else{
                        dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                        euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Icon(
                                Icons.monetization_on,
                                size: 150.0,
                                color: Colors.amber
                              ),
                              TextField(
                                controller: realController,
                                cursorColor: Colors.amber,
                                decoration: InputDecoration(
                                  labelText: "Reais",
                                  labelStyle: TextStyle(color: Colors.amber),
                                  border: OutlineInputBorder(),
                                  prefixText: "R\$",),
                                style: TextStyle(color: Colors.amber,
                                                 fontSize:25.00),
                                onChanged: _realChanged,
                                keyboardType: TextInputType.numberWithOptions(decimal:true),
                              ),
                              Divider(),
                              TextField(
                                  controller: dolarController,
                                  cursorColor: Colors.amber,
                                  decoration: InputDecoration(
                                    labelText: "Dólar",
                                    labelStyle: TextStyle(color: Colors.amber),
                                    border: OutlineInputBorder(),
                                    prefixText: "US\$",),
                                  style: TextStyle(color: Colors.amber,
                                      fontSize:25.00),
                                onChanged: _dolarChanged,
                                keyboardType: TextInputType.numberWithOptions(decimal:true),
                              ),
                              Divider(),
                              TextField(
                                  controller: euroController,
                                  cursorColor: Colors.amber,
                                  decoration: InputDecoration(
                                    labelText: "Euro",
                                    labelStyle: TextStyle(color: Colors.amber),
                                    border: OutlineInputBorder(),
                                    prefixText: "€\$",),
                                  style: TextStyle(color: Colors.amber,
                                      fontSize:25.00),
                                onChanged: _euroChanged,
                                keyboardType: TextInputType.numberWithOptions(decimal:true),
                              )
                            ],
                          ),

                        );
                      }
                  }
              },

      ), //FutureBuilder criar o widget depois que recebe(cria) os dados
    );
  }

  Future<Map> getDados() async{
    http.Response response = await http.get(request);
    print(response.body);
    return json.decode(response.body);
  }
}

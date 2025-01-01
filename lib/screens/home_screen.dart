import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              Text("Application MultiTaches",style: TextStyle(color: Colors.blueAccent,fontSize: 20),),
              SizedBox(height: 30,),
              Container(
                width: double.infinity,
                height: 100,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.all(Radius.circular(12))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Bienvenue !",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    Text("Explorer les fonctionnalite de notre application et rester informe")
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Text("information essentiel",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              SizedBox(height: 25,),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      itemContainer("Connect","connectez-vous",Icons.stacked_line_chart,Colors.blueAccent),

                      SizedBox(width: 20,),
                      itemContainer("Profile","modifier votre profile",Icons.add_alert,Colors.red[300]!),

                    ],
                  ),
                  SizedBox(height: 25,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      itemContainer("Cart","localiser les ressources",Icons.map_outlined,Colors.grey),
                      SizedBox(width: 20,),
                      itemContainer("Autre","vous interet",Icons.arrow_drop_down_circle_sharp,Colors.green[400]!),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 25,),
              Text("Conseils et Astuces",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              SizedBox(height: 25,),

              Container(
                width: double.infinity,
                height: 100,
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.all(Radius.circular(12))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Voici quelque conseils important pour rester securite et informe",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),)
                  ],
                ),
              ),

            ],

          ),
        ),
      ),
    );
  }

  Widget itemContainer(String title,String content,IconData icon,Color back){
    return Container(
      width: MediaQuery.of(context).size.width/2.5,
      height: 150,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: back,
        borderRadius: BorderRadius.all(Radius.circular(12))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon,size: 45,color: Colors.blue[100],),
          SizedBox(height: 10,),
          Text(title,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
          SizedBox(height: 10),
          Text(content,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 10),),
        ],
      ),
    );
  }
}

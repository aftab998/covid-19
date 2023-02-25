import 'package:covid19/Model/WorldStatesModel.dart';
import 'package:covid19/Services/state_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

import 'countries_list.dart';
class WorldStateScreen extends StatefulWidget {
  const WorldStateScreen({Key? key}) : super(key: key);

  @override
  State<WorldStateScreen> createState() => _WorldStateScreenState();
}

class _WorldStateScreenState extends State<WorldStateScreen> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds:3),
    vsync:this)..repeat();

  @override

  void dispose(){
    super.dispose();
    _controller.dispose();
  }
  final colorList = <Color>[
    const Color(0xff4285f4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];
  Widget build(BuildContext context) {
    StateServices stateServices = StateServices();
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .01),
                 FutureBuilder(
                   future: stateServices.fetchworldStatesRecord(),
                     builder: (context,AsyncSnapshot<WorldStatesModel> snapshot){
                   if(!snapshot.hasData){
                     return Expanded(
                       flex:1,
                       child:SpinKitFadingCircle(
                         color:Colors.white,
                         size:50.0,
                         controller:_controller
                       ),
                     );
                   }else{
                     return Column(
                       children: [
                         PieChart(
                           dataMap: {
                             'Total': double.parse(snapshot.data!.cases.toString()),
                             'Recovered':double.parse(snapshot.data!.recovered.toString()),
                             'Death': double.parse(snapshot.data!.deaths.toString()),

                           },
                           chartValuesOptions: const ChartValuesOptions(
                             showChartValuesInPercentage: true,
                           ),
                           chartRadius: MediaQuery.of(context).size.width/3.2,
                           legendOptions: const LegendOptions(
                               legendPosition: LegendPosition.left
                           ),
                           animationDuration: const Duration(milliseconds: 1200),
                           chartType: ChartType.ring,
                           colorList: colorList,

                         ),
                         Padding(
                           padding: EdgeInsets.symmetric(vertical:MediaQuery.of(context).size.height * .03),
                           child: Card(
                             child: Column(
                               children:[
                                 ReuseableRow(title: 'Total', value: snapshot.data!.cases.toString(),),
                                 ReuseableRow(title: 'Deaths', value: snapshot.data!.deaths.toString(),),
                                 ReuseableRow(title: 'Recovered', value: snapshot.data!.recovered.toString(),),
                                 ReuseableRow(title: 'Active', value: snapshot.data!.active.toString(),),
                                 ReuseableRow(title: 'Critical', value: snapshot.data!.critical.toString(),),
                                 ReuseableRow(title: 'Today Deaths', value: snapshot.data!.todayDeaths.toString(),),
                                 ReuseableRow(title: 'Today Recovered', value: snapshot.data!.todayRecovered.toString(),),



                               ],
                             ),
                           ),
                         ),
                         GestureDetector(
                           onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=> const CountriesListScreen()));
                       },
                           child: Container(
                             height:50,
                             decoration:  BoxDecoration(
                               borderRadius: BorderRadius.circular(10),
                               color: Color(0xff1aa260),
                             ),
                             child: Center(
                               child:Text('Track Countries'),
                             ),
                           ),
                         )
                       ],
                     );
                   }
                 }),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReuseableRow extends StatelessWidget {
  String title,value;
   ReuseableRow({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,top: 10,right: 10,bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          SizedBox(height: 5,),
          Divider()

        ],
      ),
    );
  }
}

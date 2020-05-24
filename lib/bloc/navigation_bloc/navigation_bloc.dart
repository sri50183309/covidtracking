import 'package:bloc/bloc.dart';
import 'package:covidtracker/model/ByIndia.dart';
import 'package:covidtracker/pages/covid_in_india.dart';
import 'package:covidtracker/pages/covid_around_world.dart';
import 'package:covidtracker/pages/covid_twits_news.dart';

enum NavigationEvents {
  DashboardClickedEvent,
  MessagesClickedEvent,
  UtilityClickedEvent
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  final Function onMenuTap;

  NavigationBloc({this.onMenuTap});

  @override
  NavigationStates get initialState => CovidAroundWorld(
        onMenuTap: onMenuTap,
      );

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.DashboardClickedEvent:
        yield CovidAroundWorld(
          onMenuTap: onMenuTap,
        );
        break;
      case NavigationEvents.MessagesClickedEvent:
        yield CovidInIndia(
          onMenuTap: onMenuTap,
        );
        break;
      case NavigationEvents.UtilityClickedEvent:
        yield CovidNews(
          onMenuTap: onMenuTap,
        );
        break;
    }
  }
}

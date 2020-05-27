import 'package:bloc/bloc.dart';
import 'package:covidtracker/sidemenu/pages/covid_around_world.dart';
import 'package:covidtracker/sidemenu/pages/covid_in_india.dart';
import 'package:covidtracker/sidemenu/pages/covid_twits_news.dart';

enum NavigationEvents {
  CovidInWorldClickedEvent,
  CovidInIndiaClickedEvent,
  CovidNewsClickedEvent
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
      case NavigationEvents.CovidInWorldClickedEvent:
        yield CovidAroundWorld(
          onMenuTap: onMenuTap,
        );
        break;
      case NavigationEvents.CovidInIndiaClickedEvent:
        yield CovidInIndia(
          onMenuTap: onMenuTap,
        );
        break;
      case NavigationEvents.CovidNewsClickedEvent:
        yield CovidNews(
          onMenuTap: onMenuTap,
        );
        break;
    }
  }
}

class NavigateCountProvider {
  int _navigateCounter = 0;
  int get navigateCounter => _navigateCounter;

  void incrementNavigateCount() {
    _navigateCounter++;
  }
}

class graphite {
  class { 'graphite::webapp': }
  include 'graphite::carbon'
}

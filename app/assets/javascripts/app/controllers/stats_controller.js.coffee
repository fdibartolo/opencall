angular.module('openCall.controllers').controller 'StatsController', 
['$scope', 'StatsService', ($scope, StatsService) ->

  $scope.customStyle = 
    color: "#337ab7"
    fontWeight: 300
    fontFamily: 'Helvetica Neue,Helvetica,Arial,sans-serif'

  $scope.byThemeChartConfig =
    options:
      credits: 
        enabled: false

      chart:
        type: 'pie'
        backgroundColor: '#f2f2f2'
        borderColor: '#337ab7'
        borderRadius: 8
        borderWidth: 1
      
      tooltip:
        useHTML: true
        headerFormat: '<div style="font-size:130%;text-align:center">{point.key}</div>'
        pointFormat: '<div style="font-size:110%;text-align:center">{point.y} proposals - {point.percentage:.1f} %</div>'

      plotOptions:
        pie:
          allowPointSelect: true
          cursor: 'pointer'
          dataLabels:
            enabled: true
            format: '<b>{point.name}</b>: {point.y}'
            style:
              color: 'black'

      style: $scope.customStyle

      loading:
        style:
          backgroundColor: '#337ab7'
          opacity: 0.7
        labelStyle: $scope.customStyle

    loading: false

    title:
      text: 'Proposals by theme'
      style: $scope.customStyle

  $scope.init = () ->
    $scope.themes = []
    colors = buildColors()
    StatsService.all().then (themes) ->
      angular.forEach themes, (theme, i) ->
        theme.active = true
        theme.color = colors[i]
        $scope.themes.push theme
      console.log $scope.themes
      $scope.buildByThemeChart()

  buildColors = () ->
    colors = []
    base = Highcharts.getOptions().colors[0]
    i = 0
    while i < 10
      colors.push Highcharts.Color(base).brighten((i - 5) / 9).get()
      i += 1
    colors

  $scope.buildByThemeChart = () ->
    $scope.byThemeChartConfig.series = [ {
      type: 'pie'
      name: 'Theme share'
      data: buildSeriesData()
    } ]

  buildSeriesData = () ->
    data = []
    angular.forEach $scope.themes, (theme, i) ->
      obj = 
        name: theme.name
        y: theme.count
        color: theme.color
      data.push obj  if theme.active

    data

  $scope.toggleTheme = (theme) ->
    theme.active = !theme.active
    $scope.buildByThemeChart()
]

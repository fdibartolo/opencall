angular.module('openCall.controllers').controller 'StatsController', 
['$scope', 'StatsService', ($scope, StatsService) ->

  $scope.customStyle = 
    color: "#337ab7"
    fontWeight: 300
    fontFamily: 'Helvetica Neue,Helvetica,Arial,sans-serif'

  $scope.init = () ->
    $scope.themes = []
    colors = buildColors()
    StatsService.all().then (themes) ->
      angular.forEach themes, (theme, i) ->
        theme.active = true
        theme.color = colors[i]
        $scope.themes.push theme
      $scope.buildByThemeChart()
      $scope.buildByReviewsChart()

  buildColors = () ->
    colors = []
    base = Highcharts.getOptions().colors[0]
    i = 0
    while i < 10
      colors.push Highcharts.Color(base).brighten((i - 5) / 9).get()
      i += 1
    colors

  $scope.buildByThemeChart = () ->
    $scope.byThemeChartConfig =
      options:
        credits: 
          enabled: false

        chart:
          type: 'pie'
          backgroundColor: '#fafafa'
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

      series: [ {
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

  $scope.buildByReviewsChart = () ->
    $scope.byReviewsChartConfig =
      options:
        credits: 
          enabled: false

        chart:
          type: 'column'
          backgroundColor: '#fafafa'
          borderColor: '#337ab7'
          borderRadius: 8
          borderWidth: 1
        
        tooltip:
          shared: true
          useHTML: true
          headerFormat: '<div style="font-size:130%;text-align:center">{point.key}</div>'

        yAxis:
          min: 0
          allowDecimals: false
          gridLineColor: "#999999"
          gridLineWidth: 1
          gridLineDashStyle: 'dot'
          title:
            text: ""
          labels:
            style: $scope.customStyle

        plotOptions:
          column:
            allowPointSelect: true
            cursor: 'pointer'
            grouping: false
            dataLabels:
              enabled: true
              format: '{point.y}'
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
        text: 'Proposals by Reviews'
        style: $scope.customStyle

      xAxis:
        title:
          style: $scope.customStyle
        categories: theme.name for theme in $scope.themes when theme.active
        allowDecimals: false
        labels:
          style:
            color: 'black'
          staggerLines: 1

      series: [
        {
          name: 'Total'
          data: theme.count for theme in $scope.themes when theme.active
          color: Highcharts.getOptions().colors[0]
          pointPadding: 0
        }
        {
          name: 'Total Reviewed'
          data: theme.reviewed for theme in $scope.themes when theme.active
          color: 'rgba(0,220,0,0.5)'
          pointPadding: 0.2
        }
      ]

  $scope.toggleTheme = (theme) ->
    theme.active = !theme.active
    $scope.buildByThemeChart()
    $scope.buildByReviewsChart()
]

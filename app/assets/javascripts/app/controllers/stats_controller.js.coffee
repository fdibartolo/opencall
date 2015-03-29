angular.module('openCall.controllers').controller 'StatsController', 
['$scope', '$location', '$anchorScroll', '$timeout', 'StatsService', ($scope, $location, $anchorScroll, $timeout, StatsService) ->

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

  $scope.toggleTheme = (theme) ->
    theme.active = !theme.active
    $scope.buildByThemeChart()
    $scope.buildByReviewsChart()

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
          series:
            point:
              events:
                select: () ->
                  StatsService.get(this.category).then (theme) ->
                    $scope.buildThemeDetailsChart theme
                    $scope.themeDetailChartVisible = true
                    $timeout (->
                      $location.hash('scroll-to-bottom'); $anchorScroll()
                      return
                    ), 200

        style: $scope.customStyle

      title:
        text: 'Proposals by Reviews'
        style: $scope.customStyle

      subtitle:
        text: 'click on a theme to view details'

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
          color: Highcharts.getOptions().colors[2]
          pointPadding: 0.2
        }
      ]

  $scope.buildThemeDetailsChart = (theme) ->
    $scope.themeDetailsChartConfig =
      options:
        credits: 
          enabled: false

        chart:
          type: 'bar'
          backgroundColor: '#fafafa'
          borderColor: '#337ab7'
          borderRadius: 8
          borderWidth: 1
        
        legend:
          enabled: false

        tooltip:
          useHTML: true
          headerFormat: '<div style="font-size:130%;text-align:center">{point.key}</div>'

        yAxis:
          min: 0
          max: 10
          allowDecimals: true
          gridLineColor: "#999999"
          gridLineWidth: 1
          gridLineDashStyle: 'dot'
          title:
            text: 'Score'
          labels:
            overflow: 'justify'
            style: $scope.customStyle

        plotOptions:
          bar:
            cursor: 'pointer'
            dataLabels:
              enabled: false

        style: $scope.customStyle

      title:
        text: theme.name
        style: $scope.customStyle

      xAxis:
        title:
          style: $scope.customStyle
        categories: proposal.name for proposal in theme.proposals
        labels:
          style:
            color: 'black'
          staggerLines: 1

      series: buildDetailsSeriesData(theme.proposals)

  buildDetailsSeriesData = (proposals) ->
    matrix = []
    angular.forEach proposals, (proposal) ->
      matrix.push proposal.reviews

    transposed = transpose(matrix)

    data = []
    for i in [0..transposed.length-1]
      data.push { name: 'Score', data: transposed[i], color: Highcharts.getOptions().colors[0]}
    data.push { name: 'Average', data: buildAverageSerie(proposals), color: Highcharts.getOptions().colors[2]}
    data

  transpose = (matrix) ->
    (t[i] for t in matrix) for i in [0...matrix[0].length]

  buildAverageSerie = (proposals) ->
    data = []
    angular.forEach proposals, (proposal) ->
      count = proposal.reviews.length
      average = if count is 0 then 0 else (proposal.reviews.reduce (t, s) -> t + s)/count
      data.push average
    data

]

angular.module('Jabong', ['isteven-multi-select'])
.directive 'wdSelect', () ->
  restrict: 'E'
  scope:
    inputModel: '=inputModel'
    outputModel: '=outputModel'
    singleSelect: '=singleSelect'
  templateUrl: './templates/dir_select.html'
  replace: true
  controller: ($scope, $log) ->
    $scope.options = [
      {name: 'option'}
    ]
    $scope.$watchCollection(
      'inputModel',
      (nVal, oVal) ->
        $scope.options = _.map(nVal.values, (v) ->
          res = {name: v}
          if _.contains($scope.outputModel, v)
            res.selected = true
          res
        )
    )

    $scope.$watchCollection(
      'selected',
      (nVal, oVal) ->
        res = _.map(nVal, (o) ->
          o.name
        )
        if $scope.singleSelect
          $scope.outputModel = res[0]
        else
          $scope.outputModel = res
    )

    $scope.$watchCollection(
      'outputModel',
      (nVal, oVal) ->
        if nVal != oVal
          if $scope.singleSelect
            nValues = [nVal]
          else
            nValues = nVal
          _.each($scope.options, (v, k) ->
            v.selected = _.contains(nValues, v.name)
          )
    )
.controller 'MainCtrl', ($scope, $log, $http) ->

  $scope.data = {}
  $scope.edata = {}
  $scope.selected = {
    percent: 0
  }
  $scope.excluded = {}
  $scope.loading = true
  $scope.submitting = false

  $http.get 'http://45.55.72.208/misc/jabong/form'
  .success (data) ->
    $scope.loading = false
    _.each(data, (obj) ->
      $scope.data[obj.name] = obj
      $scope.edata[obj.name] = obj
    )


  $scope.submit = () ->
    $scope.submitting = true
    $log.debug "About to submit: "+JSON.stringify($scope.selected)
    $http.post 'http://45.55.72.208/misc/jabong/post', {
     selected: $scope.selected
     excluded: $scope.excluded
    }
    .success (data) ->
      $scope.submitting = false
      if data.success
        alert "Successful submission"
      else
        alert "Some problem occurred while submitting"

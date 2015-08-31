// Generated by CoffeeScript 1.9.3
(function() {
  angular.module('Jabong', ['isteven-multi-select']).directive('wdSelect', function() {
    return {
      restrict: 'E',
      scope: {
        inputModel: '=inputModel',
        outputModel: '=outputModel',
        singleSelect: '=singleSelect'
      },
      templateUrl: './templates/dir_select.html',
      replace: true,
      controller: function($scope, $log) {
        $scope.options = [
          {
            name: 'option'
          }
        ];
        $scope.$watchCollection('inputModel', function(nVal, oVal) {
          return $scope.options = _.map(nVal.values, function(v) {
            var res;
            res = {
              name: v
            };
            if (_.contains($scope.outputModel, v)) {
              res.selected = true;
            }
            return res;
          });
        });
        $scope.$watchCollection('selected', function(nVal, oVal) {
          var res;
          res = _.map(nVal, function(o) {
            return o.name;
          });
          if ($scope.singleSelect) {
            return $scope.outputModel = res[0];
          } else {
            return $scope.outputModel = res;
          }
        });
        return $scope.$watchCollection('outputModel', function(nVal, oVal) {
          var nValues;
          if (nVal !== oVal) {
            if ($scope.singleSelect) {
              nValues = [nVal];
            } else {
              nValues = nVal;
            }
            return _.each($scope.options, function(v, k) {
              return v.selected = _.contains(nValues, v.name);
            });
          }
        });
      }
    };
  }).controller('MainCtrl', function($scope, $log, $http) {
    $scope.data = {};
    $scope.selected = {};
    $scope.loading = true;
    $http.get('http://45.55.72.208/misc/jabong/form').success(function(data) {
      $scope.loading = false;
      return _.each(data, function(obj) {
        return $scope.data[obj.name] = obj;
      });
    });
    return $scope.submit = function() {
      return $http.post('http://45.55.72.208/misc/jabong/post', $scope.selected).success(function(data) {
        return $log.info("Got data: " + JSON.stringify(data));
      });
    };
  });

}).call(this);

//# sourceMappingURL=app.js.map

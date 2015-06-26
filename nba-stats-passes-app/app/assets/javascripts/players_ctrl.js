(function() {
  "use strict";

  angular.module("app").controller("playersCtrl", function($scope, $http) {
    
    $scope.fetchData = function() {
      $http.get("/api/v1/players.json").then(function(response) {
        $scope.players = response.data["players"];
      });
    };

// Added player show function
    $scope.fetchPlayerData = function() {
    	$http.get("/api/v1/players/show.json", player).then(function(response) { 
    		$scope.details = response.data['details'];
    	});
    };

    window.scope = $scope;

  });
})();

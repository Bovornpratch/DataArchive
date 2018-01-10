'use strict';

// Register `phase2rotator` component, along with its associated controller and template
angular.
module('phase2Rotator').
component('phase2Rotator', {
    templateUrl: 'phase2-rotator/phase2-rotator.template.html',
    controller: [ '$http',
        function($http) {

            var self = this;

            self.loadHelloWorld = function () {

                $http.get("server-side/generate_hello_world.py").success(function (data) {
                    console.log(data);
                    fs.createWriteStream().write(data);
                }).error(function() {
                    alert("Python script not found.");
                })
            }

        }
    ]
});

require 'mocha/setup'
Deployment.any_instance.stubs(:schedule_deploy).returns {logger.log '1'}
NodeBuilder.any_instance.stubs(:build).returns { self.logger.log 'node build' }

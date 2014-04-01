module DeploymentsHelper
  def deployment_status(deployment)
    result = {
        'processing' => 'warning',
        'initial' => 'info'
    }[deployment.state]

    return result if result

    deployment.success ? 'success' : 'danger'
  end

  def deployment_status_icon(deployment)
    result = {
        'processing' => 'spinner fa fa-spin',
        'initial' => 'play'
    }[deployment.state]

    return result if result

    deployment.success ? 'flag' : 'ambulance'
  end
end

module ApplicationHelper
  def bootstrap_class_for(flash_type)
    case flash_type
    when 'notice'
      'alert-success'   # success (green)
    when 'alert'
      'alert-danger'    # error (red)
    when 'error'
      'alert-danger'    # error (red)
    when 'warning'
      'alert-warning'   # warning (yellow)
    else
      'alert-info'      # generic info (blue)
    end
  end
end

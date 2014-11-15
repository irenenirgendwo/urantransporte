# encoding: utf-8
module UmschlaegeHelper

 def new_transport_umschlag_path(transport)
    link_url = new_umschlag_path
    link_url += "?transport_id=#{@transport.id}"
  end
end

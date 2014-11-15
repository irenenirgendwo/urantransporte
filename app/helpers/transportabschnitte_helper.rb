# encoding: utf-8
module TransportabschnitteHelper

  def new_transport_transportabschnitt_path(transport)
    link_url = new_transportabschnitt_path
    link_url += "?transport_id=#{@transport.id}"
  end
end

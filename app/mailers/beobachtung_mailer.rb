class BeobachtungMailer < ApplicationMailer

  default from: 'irene@nirgendwo.info'
 
  def benachrichtigung(beobachtung, url)
    @quelle = beobachtung.quelle
    @url  = url
    @beobachtung = beobachtung
    User.get_admin_mails.each do |mail|
      mail(to: "irene@nirgendwo.info", subject: 'Atomtransport-DB: Neue Beobachtung')
    end
  end
  
end

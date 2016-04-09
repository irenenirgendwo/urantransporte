class BeobachtungMailer < ApplicationMailer

  default from: 'urantransport@nirgendwo.info'
 
  def benachrichtigung(beobachtung, url)
    @quelle = beobachtung.quelle
    @url  = url
    @beobachtung = beobachtung
    User.get_admin_mails.each do |mail|
      mail(to: mail, subject: 'Atomtransport-DB: Neue Beobachtung')
    end
  end
  
end

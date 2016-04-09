class BeobachtungMailer < ApplicationMailer

  default from: 'urantransport@nirgendwo.info'
 
  def benachrichtigung(beobachtung, url, email)
    @quelle = beobachtung.quelle
    @url  = url
    @beobachtung = beobachtung
    mail(to: email, subject: 'Atomtransport-DB: Neue Beobachtung')
  end
  
end

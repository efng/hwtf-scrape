= hwtf-scrape
scrapes reddit &amp; mturkgrind for new mturk links
== Description

== Dependencies

* ruby 2.0 
* rails 4.0.2 
* [activejob_backport] to use the 4.2 Rails Active job queue system with raisl 4.0
* []
    DelayJobs (DJ) for job queueing
    Mechnize[https://github.com/sparklemotion/mechanize] to webscrape mturkgrind for valid links
    RedditKit[https://github.com/samsymons/RedditKit.rb] to scrape /r/HITsWorthTurkingFor[http://www.reddit.com/r/HITsWorthTurkingFor/]
* nokogiri[https://github.com/sparklemotion/nokogiri]

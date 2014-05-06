Data.com Harvester
=========

Apllication contains data.com search agent, SugarCRM updater and website to display update status logs.
PhantomJs is used as Watir driver, because it can see website data added by JS.
Whenever gem is used to run every 3 hours task *rake sugarcrm:update*, which updates first 10 SugarCRM accounts corresponding to conditions.

Requirements
---
  - Ruby 2.1.1-p76
  - Rails 4.1.0.rc2
  - PhantomJs installed

Installation
--------------

```sh
sudo apt-get install phantomjs
git clone git@github.com:dkonovalchuk/datacom_harvester.git
cd datacom_harvester && bundle
cd config
cp datacom.sample.yml datacom.yml && cp sugarcrm.sample.yml sugarcrm.yml (and fill those files with correct data)
rails s
```

For more information see code comments.
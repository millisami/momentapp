# Momentapp

## Description
Momentapp is a ruby wrapper for the [Momentapp][momentapp] service.

### Installation

    gem install momentapp
    
### Usage

**Configure**

    Momentapp::Config.api_key = [Your api key that you can get from http://momentapp.com]

**Schedule a new job**

    target_uri = "http://kasko.com"
    http_method = "GET"
    at = '2012-01-31T18:36:21'
    params = {:var1 => true, :var2 => false, :var3 => "ok"}
    options = {:limit => 3, :callback_uri => "http://callback.com/public/listener"}
    
    job = Momentapp.create_job(target_uri, http_method, at, params, options)
    job.id      #=> "n9hYHhc1"
    job.uri     #=> "http://kasko.com:80/?var1=true&var2=false&var3=ok"
    job.http_method  #=> "GET"
    job.at      #=> '2012-02-01 08:21:21 +0545'

**Updating a existing job**
  
    job_id = job.id
    target_uri = "http://tesko.com"
    http_method = "POST"
    options = {}
  
    job_update = Momentapp.update_job(job_id, target_uri, http_method, at, params, options)
  
**Deleting the job**

    job_id = job.id

    new_result = Momentapp.delete_job(job_id)
    new_result.message #=> 'Job deleted'

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with Rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011 Millisami. See LICENSE for details.

[momentapp]: http://momentapp.com
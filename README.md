#Yad2.2

##What?
This project is aimed for those who're searching for an apartment and tired of refreshing [Yad2](http://yad2.co.il) manually during the day.
It gives you clean result pages for yad2 <b>rent apartment</b> queries, that will automatically fetches new results every few minutes.  All the results are synced with your local database, including your own notes.

##How?
Sinatra server, Poltergeist and Capybara.

###Prerequisites
<ul>
  <li>
    Ruby >= 1.9 
  </li>
  <li>
    PhantomJS >= 1.8
  </li>
  <li>
    Mongo db
  </li>
</ul>


###Starting the server
```
bundle install
rackup
```
###Creating a feed:
Go to [Yad2](http://yad2.co.il), filter your ads using the search and copy the query parameter.
Go to [http://localhost:9292](http://localhost:9292), and paste the query in the text field.

A new tab will be opened with the query results. As long as the tab is opened, it will automatically fetch new results every few minutes.   

##Acknowledgement
This project is based on previous works by [@shaiguitar](http://github.com/shaiguitar), and [@almog](https://github.com/almog). 
It was forked from [almog/yad2.rss](https://github.com/almog/yad2.rss).

import{s as O,f as d,g as c,I as T,j as n,i as y,y as u,d as r,a as L,l as N,c as F,h as g,m as U,x as l,C as G,E as Xe}from"../chunks/scheduler.2037d42e.js";import{S as _,i as $,b as C,d as A,m as I,a as w,t as x,e as D,g as Qe,c as Ye}from"../chunks/index.cd713282.js";import{L as Ze}from"../chunks/Layout.b983af79.js";function et(i){let e,a=`<div class="m-4"><h1 class="text-3xl font-bold my-4">System Architecture</h1> <p class="my-2">OpenFPL is being built as a progressive web application, it&#39;s curernt
      frontend is React but will be moved over to Svelte for the start of 2024.
      The OpenFPL backend is developed in Motoko. The Github is publicly
      available at github.com/jamesbeadle/openfpl. OpenFPL&#39;s architecture is
      designed for scalability and efficiency, ensuring robust performance even
      as user numbers grow. Here&#39;s how the system is structured:</p> <h2 class="text-lg font-bold mt-4">Profile Data</h2> <p class="my-2">OpenFPL allocates approximately 254 bytes for a profile record. This means
      that a single Profile Canister could hold more than 16m profiles, scaling
      to a size larger than the market leader.</p> <p class="my-2">Each profile record will hold a reference to the Profile Picture canister
      where their pfp is stored. We limit the size of profile pictures to 500KB,
      meaning you can store 8,000 images per Profile Picture canister. When the
      canister is full, a new Profile Picture canister is created to store the
      images.</p> <h2 class="text-lg font-bold mt-4">Fantasy Teams Data</h2> <p class="my-2">OpenFPL allocates approximately 913 KB for a fantasy team with a lifetime
      of seasons history. Therefore we can store over 4,000 fantasy teams in
      each canister. When this limit is reached, a new canister is created. A
      reference to the user’s Fantasy Team canister is stored in the user
      profile record.</p> <h2 class="text-lg font-bold mt-4">Leaderboard Data</h2> <p class="my-2">The size of the leaderboard data is very much dependent on the number of
      users on the site as each will create an entry in each leaderboard.
      Therefore we will create a new canister for each leaderboard. For each
      season there will be a Season Leaderboard canister, 38 Gameweek
      Leaderboard canisters and 12 Monthly Leaderboard canisters. This
      architecture will scale to 25m+ users, more than double the players of the
      market leading platform.</p> <h2 class="text-lg font-bold mt-4">Main Canister &amp; Central Data Management</h2> <p class="my-2">Our system estimates the size of the main canister containing data for 100
      seasons as around 44MB. With around 1% of the 4GB canister being used,
      substantial room is available for additional growth and functionalities.
      The Main canister will contain the following key pieces of information:</p> <ul class="list-disc ml-4"><li>Data Cache Hashes</li> <li>Teams Data</li> <li>Seasons Data</li> <li>Canister References</li></ul> <h2 class="text-lg font-bold mt-4">Player Canisters</h2> <p class="my-2">The player canisters container information on all Premier League football
      players. OpenFPL allocates approximately 30 KB for each Player record.
      With a single canister on the Internet Computer boasting a 4GB capacity,
      it will be able to store 100.000+ Premier League player entries. Each
      Premier League team could theoretically introduce up to 50 new players per
      team annually. However, this number implies a complete change of a team&#39;s
      squad, an eventuality that&#39;s exceedingly uncommon in the Premier League.
      Therefore, our projection of 1,000 new players across the league each year
      offers a deliberately conservative overestimation. Given these
      calculations, the following 3 canisters will be able to manage all the
      Premier League players for well over 100 years:</p> <ul class="list-disc ml-4"><li>Live Players Canister</li> <li>Former Players Canister</li> <li>Retired Players Canister</li></ul> <p class="my-2">Players will move from the live canister to and from the Former or Retired
      players canister when required.</p> <h2 class="text-lg font-bold mt-4">Cycle Dispenser</h2> <p class="my-2">The cycle dispenser canister watches each canister in the OpenFPL
      ecosystem and tops it up with cycles when it reaches 20% of its top up
      value.</p> <h2 class="text-lg font-bold mt-4">Note on Architecture Evolution and Whitepaper Updates</h2> <p class="my-2">As OpenFPL progresses through the SNS testflight phase, our architecture
      may undergo changes to optimize performance and scalability. We are
      committed to staying at the forefront of technological advancements,
      ensuring that our platform remains robust and efficient.</p> <p class="my-2">To keep our community and stakeholders informed, any significant changes
      to the architecture will be reflected in updated versions of this
      whitepaper. Each new version will be clearly marked to ensure transparency
      and ease of reference, maintaining our commitment to openness and
      communication with our users.</p></div>`;return{c(){e=d("div"),e.innerHTML=a,this.h()},l(t){e=c(t,"DIV",{class:!0,"data-svelte-h":!0}),T(e)!=="svelte-1ekpky2"&&(e.innerHTML=a),this.h()},h(){n(e,"class","container-fluid mx-auto p-4")},m(t,s){y(t,e,s)},p:u,i:u,o:u,d(t){t&&r(e)}}}class tt extends _{constructor(e){super(),$(this,e,null,et,O,{})}}function at(i){let e,a=`<div class="m-4"><h1 class="text-3xl font-bold">OpenFPL DAO</h1> <p class="my-4">OpenFPL functions entirely on-chain as a DAO, aspiring to operate under
      the Internet Computer’s Service Nervous System. The DAO is structured to
      run in parallel with the Premier League season, relying on input from its
      neuron holders who are rewarded for maintaining independence from
      third-party services.</p> <h2 class="text-xl font-bold">DAO Reward Structure</h2> <p class="my-2">The DAO incentivizes participation through monthly minting of new FPL
      tokens, calculated annually as 2.5% of the total $FPL supply as of August
      1st. These tokens are allocated to:</p> <ul class="list-disc ml-4"><li>Gameplay Rewards (75%)</li> <li>Governance Rewards (25%)</li></ul> <h2 class="text-lg font-bold mt-4">Gameplay Rewards (75%)</h2> <p class="my-2">The DAO is designed to reward users for their expertise in fantasy
      football, with rewards distributed weekly, monthly, and annually based on
      performance. The rewards are tiered to encourage ongoing engagement.
      Here’s the breakdown:</p> <ul class="list-disc ml-4"><li>Global Season Leaderboard Rewards: 30% for the top 100 global season
        positions.</li> <li>Club Monthly Leaderboard Rewards: 20% for the top 100 in each monthly
        club leaderboard, adjusted for the number of fans in each club.</li> <li>Global Weekly Leaderboard Rewards: 15% for the top 100 weekly positions.</li> <li>Most Valuable Team Rewards: 10% for the top 100 most valuable teams at
        season&#39;s end.</li> <li>Highest Scoring Match Player Rewards: 10% split among managers selecting
        the highest-scoring player in a fixture.</li> <li>Weekly/Monthly/Season ATH Score Rewards: 5% each, reserved for breaking
        all-time high scores in respective categories.</li></ul> <p class="my-2">A user is rewarded for their leaderboard position across the top 100
      positions. The following is a breakdown of the reward share for each
      position:</p> <table class="w-full text-center border-collapse striped mb-8 mt-8 svelte-58jp75"><tr class="svelte-58jp75"><th>Pos</th> <th>Share</th> <th>Pos</th> <th>Share</th> <th>Pos</th> <th>Share</th> <th>Pos</th> <th>Share</th></tr> <tr class="svelte-58jp75"><td>1</td> <td>36.09%</td> <td>26</td> <td>0.391%</td> <td>51</td> <td>0.0662%</td> <td>76</td> <td>0.012%</td></tr> <tr class="svelte-58jp75"><td>2</td> <td>18.91%</td> <td>27</td> <td>0.365%</td> <td>52</td> <td>0.0627%</td> <td>77</td> <td>0.0112%</td></tr> <tr class="svelte-58jp75"><td>3</td> <td>10.32%</td> <td>28</td> <td>0.339%</td> <td>53</td> <td>0.0593%</td> <td>78</td> <td>0.0103%</td></tr> <tr class="svelte-58jp75"><td>4</td> <td>6.02%</td> <td>29</td> <td>0.314%</td> <td>54</td> <td>0.0558%</td> <td>79</td> <td>0.0095%</td></tr> <tr class="svelte-58jp75"><td>5</td> <td>3.87%</td> <td>30</td> <td>0.288%</td> <td>55</td> <td>0.0524%</td> <td>80</td> <td>0.0086%</td></tr> <tr class="svelte-58jp75"><td>6</td> <td>2.80%</td> <td>31</td> <td>0.262%</td> <td>56</td> <td>0.0490%</td> <td>81</td> <td>0.0082%</td></tr> <tr class="svelte-58jp75"><td>7</td> <td>2.26%</td> <td>32</td> <td>0.248%</td> <td>57</td> <td>0.0455%</td> <td>82</td> <td>0.0077%</td></tr> <tr class="svelte-58jp75"><td>8</td> <td>1.83%</td> <td>33</td> <td>0.235%</td> <td>58</td> <td>0.0421%</td> <td>83</td> <td>0.0073%</td></tr> <tr class="svelte-58jp75"><td>9</td> <td>1.51%</td> <td>34</td> <td>0.221%</td> <td>59</td> <td>0.0387%</td> <td>84</td> <td>0.0069%</td></tr> <tr class="svelte-58jp75"><td>10</td> <td>1.30%</td> <td>35</td> <td>0.207%</td> <td>60</td> <td>0.0352%</td> <td>85</td> <td>0.0064%</td></tr> <tr class="svelte-58jp75"><td>11</td> <td>1.19%</td> <td>36</td> <td>0.193%</td> <td>61</td> <td>0.0335%</td> <td>86</td> <td>0.0060%</td></tr> <tr class="svelte-58jp75"><td>12</td> <td>1.08%</td> <td>37</td> <td>0.180%</td> <td>62</td> <td>0.0318%</td> <td>87</td> <td>0.0056%</td></tr> <tr class="svelte-58jp75"><td>13</td> <td>0.98%</td> <td>38</td> <td>0.166%</td> <td>63</td> <td>0.0301%</td> <td>88</td> <td>0.0052%</td></tr> <tr class="svelte-58jp75"><td>14</td> <td>0.87%</td> <td>39</td> <td>0.152%</td> <td>64</td> <td>0.0284%</td> <td>89</td> <td>0.0047%</td></tr> <tr class="svelte-58jp75"><td>15</td> <td>0.76%</td> <td>40</td> <td>0.138%</td> <td>65</td> <td>0.0266%</td> <td>90</td> <td>0.0043%</td></tr> <tr class="svelte-58jp75"><td>16</td> <td>0.72%</td> <td>41</td> <td>0.131%</td> <td>66</td> <td>0.0249%</td> <td>91</td> <td>0.0041%</td></tr> <tr class="svelte-58jp75"><td>17</td> <td>0.67%</td> <td>42</td> <td>0.125%</td> <td>67</td> <td>0.0232%</td> <td>92</td> <td>0.0039%</td></tr> <tr class="svelte-58jp75"><td>18</td> <td>0.63%</td> <td>43</td> <td>0.118%</td> <td>68</td> <td>0.0215%</td> <td>93</td> <td>0.0037%</td></tr> <tr class="svelte-58jp75"><td>19</td> <td>0.59%</td> <td>44</td> <td>0.111%</td> <td>69</td> <td>0.0198%</td> <td>94</td> <td>0.0034%</td></tr> <tr class="svelte-58jp75"><td>20</td> <td>0.55%</td> <td>45</td> <td>0.104%</td> <td>70</td> <td>0.0180%</td> <td>95</td> <td>0.0032%</td></tr> <tr class="svelte-58jp75"><td>21</td> <td>0.52%</td> <td>46</td> <td>0.097%</td> <td>71</td> <td>0.0172%</td> <td>96</td> <td>0.0030%</td></tr> <tr class="svelte-58jp75"><td>22</td> <td>0.49%</td> <td>47</td> <td>0.090%</td> <td>72</td> <td>0.0155%</td> <td>97</td> <td>0.0028%</td></tr> <tr class="svelte-58jp75"><td>23</td> <td>0.47%</td> <td>48</td> <td>0.083%</td> <td>73</td> <td>0.0146%</td> <td>98</td> <td>0.0026%</td></tr> <tr class="svelte-58jp75"><td>24</td> <td>0.44%</td> <td>49</td> <td>0.076%</td> <td>74</td> <td>0.0137%</td> <td>99</td> <td>0.0024%</td></tr> <tr class="svelte-58jp75"><td>25</td> <td>0.42%</td> <td>50</td> <td>0.070%</td> <td>75</td> <td>0.0129%</td> <td>100</td> <td>0.0021%</td></tr></table> <p class="my-2">To ensure rewards are paid for active participation, a user would need to
      do the following to qualify for the following OpenFPL gameplay rewards:</p> <ul class="list-disc ml-4"><li>A user must have made at least 2 changes in a month to qualify for that
        month&#39;s club leaderboard rewards and monthly ATH record rewards.</li> <li>A user must have made at least 1 change in a gameweek to qualify for
        that week&#39;s leaderboard rewards, highest-scoring match player rewards
        and weekly ATH record rewards.</li> <li>Rewards for the season total, most valuable team have and annual ATH
        have no entry restrictions as it is based on the cumulative action of
        managers transfers throughout the season.</li></ul> <h2 class="text-lg font-bold mt-4">Governance Rewards (25%)</h2> <p class="my-2">OpenFPL values neuron holders&#39; contributions to maintaining up-to-date
      Premier League data. Rewards are given for raising and voting on essential
      proposals, such as scheduling, player transfers, and updating player
      information. Failed proposals incur a 10 $FPL cost, contributing to the
      DAO’s treasury.</p> <p class="my-4">The OpenFPL DAO is an innovative approach to fantasy football, combining
      real-time data accuracy with rewarding community involvement. By aligning
      rewards with active participation, OpenFPL ensures a vibrant, informed,
      and engaged user base.</p></div>`;return{c(){e=d("div"),e.innerHTML=a,this.h()},l(t){e=c(t,"DIV",{class:!0,"data-svelte-h":!0}),T(e)!=="svelte-1vyx208"&&(e.innerHTML=a),this.h()},h(){n(e,"class","container-fluid mx-auto p-4")},m(t,s){y(t,e,s)},p:u,i:u,o:u,d(t){t&&r(e)}}}class st extends _{constructor(e){super(),$(this,e,null,at,O,{})}}function it(i){let e,a=`<div class="m-4"><h1 class="text-3xl font-bold">OpenFPL Gameplay</h1> <p class="my-4">At OpenFPL, our gameplay rules are designed to create an immersive,
      engaging, and unique fantasy football experience. We understand the
      passion and strategy that goes into fantasy football, and our gameplay
      rules are crafted to reflect this, enhancing the fun and competitiveness
      of each gameweek.</p> <h2 class="text-lg font-bold">Starting Funds and Team Composition</h2> <p class="my-2">Each user begins their journey with £300m, a budget to strategically build
      their dream team. The value of players fluctuates based on community
      ratings within the DAO. If a player&#39;s performance garners enough votes,
      their value can either increase or decrease by £0.25m each gameweek.</p> <p class="my-2">In terms of team structure, each user&#39;s team consists of 11 players.
      Picking from a range of clubs is key, so a maximum of two players from any
      single club can be selected. Teams must adhere to a valid formation: 1
      goalkeeper, 3-5 defenders, 3-5 midfielders, and 1-3 strikers.</p> <h2 class="text-lg font-bold mt-4">Transfers and Team Management</h2> <p class="my-2">Flexibility is a cornerstone of our gameplay. Users can make up to three
      transfers per week, allowing for dynamic team management and adaptation to
      the ever-changing football landscape. These transfers don&#39;t roll over,
      encouraging active participation each week. There are no substitutes in
      our game, eliminating the frustration of unused bench points.</p> <p class="my-2">Each January, users can overhaul their team completely once, adding
      another strategic layer to the game reflecting the January transfer
      window.</p> <h2 class="text-lg font-bold mt-4">Scoring System</h2> <p class="my-2">Our scoring system rewards players for key contributions on the field:</p> <ul class="list-disc ml-4"><li>Appearing in the game: +5 points</li> <li>Every 3 saves a goalkeeper makes: +5 points</li> <li>Goalkeeper or defender cleansheet: +10 points</li> <li>Forward scores a goal: +10 points</li> <li>Midfielder or Forward assists a goal: +10 points</li> <li>Midfielder scores a goal: +15 points</li> <li>Goalkeeper or defender assists a goal: +15 points</li> <li>Goalkeeper or defender scores a goal: +20 points</li> <li>Goalkeeper saves a penalty: +20 points</li> <li>Player is highest scoring player in match: +25 points</li></ul> <p class="my-2">Points are also deducted for the following on field events:</p> <ul class="list-disc ml-4"><li>Player receives a red card: -20 points</li> <li>Player misses a penalty: -15 points</li> <li>Each time a goalkeeper or defender concedes 2 goals: -15 points</li> <li>A player scores an own goal: -10 points</li> <li>A player receives a yellow card: -5 points</li></ul> <h2 class="text-lg font-bold mt-4">Bonuses</h2> <p class="my-2">OpenFPL elevates the gameplay with a diverse set of bonuses. These bonuses
      play a pivotal role in keeping OpenFPL&#39;s gameplay both fresh and
      exhilarating. Their strategic implementation allows for significant shifts
      in the leaderboard, ensuring that the competition remains open and
      dynamic. With these bonuses, any user, regardless of their position, has
      the potential to make a substantial leap in the rankings. This
      unpredictability means that victory is within reach for every participant,
      fostering a thrilling environment where every gameweek holds the promise
      of a shake-up at the top of the leaderboard. Our bonuses are as follows:</p> <ul class="list-disc ml-4"><li>Goal Getter: X3 multiplier for each goal scored by a selected player.</li> <li>Pass Master: X3 multiplier for each assist by a selected player.</li> <li>No Entry: X3 multiplier for a selected goalkeeper/defender for a clean
        sheet.</li> <li>Safe Hands: X3 multiplier for a goalkeeper making 5 saves.</li> <li>Captain Fantastic: X2 multiplier on the captain’s score for scoring a
        goal.</li> <li>Team Boost: X2 multiplier for all players from a single club.</li> <li>Brace Bonus: X2 multiplier for any player scoring 2+ goals.</li> <li>Hat-Trick Hero: X3 multiplier for any player scoring 3+ goals.</li> <li>Countrymen: Double points for players of a selected nationality.</li> <li>Youth Prospects: Double points for players under 21.</li></ul> <h2 class="text-lg font-bold mt-4">Star Player</h2> <p class="my-2">Each week a user can select a star player. This player will receive double
      points for the gameweek. If one is not set by the start of the gameweek it
      will automatically be set to the most valuable player in your team.</p> <p class="my-4">OpenFPL&#39;s gameplay combines strategic team management, a dynamic scoring
      system, and diverse bonuses, offering a unique and competitive fantasy
      football experience. Each decision impacts your journey through the
      Premier League season, where football knowledge and strategy lead to
      rewarding outcomes.</p></div>`;return{c(){e=d("div"),e.innerHTML=a,this.h()},l(t){e=c(t,"DIV",{class:!0,"data-svelte-h":!0}),T(e)!=="svelte-ibzsho"&&(e.innerHTML=a),this.h()},h(){n(e,"class","container-fluid mx-auto p-4")},m(t,s){y(t,e,s)},p:u,i:u,o:u,d(t){t&&r(e)}}}class nt extends _{constructor(e){super(),$(this,e,null,it,O,{})}}function ot(i){let e,a=`<div class="m-4"><h1 class="text-3xl font-bold">Marketing</h1> <p class="my-4">We will be marketing both online and in-person, taking advantage of being
      based in the UK and having access to millions of Premier League fans.</p> <h2 class="text-xl font-bold mb-4">Online Marketing Strategy</h2> <h2 class="text-lg font-bold">Collaboration with Digitial Marketing Agency</h2> <p class="my-2">We are engaging with a digital marketing agency known for their experience
      working with startups in the digital space. This agency is in the process
      of finalising plans for a comprehensive online marketing campaign. The
      campaign will focus on PPC (Pay-Per-Click) and SEO (Search Engine
      Optimisation) strategies, with an emphasis on reaching specific user
      groups effectively.</p> <h2 class="text-lg font-bold mt-4">Initial Strategy and Goals</h2> <p class="my-2">We will have a particular focus on the UK market for initial traction.
      Tracking success through KPIs, focusing on manager sign-ups and event
      attendance.</p> <h2 class="text-lg font-bold mt-4">OpenFPL&#39;s Initiatives</h2> <p class="my-2">Our approach is to seamlessly integrate OpenFPL&#39;s online marketing
      campaigns with our broader initiatives. A key focus will be on targeted
      local advertising, aiming to highlight the distribution of 200 junior
      football club kits to grassroots football causes across the UK.
      Additionally, we&#39;ve created a return on investment (ROI) leaderboard for
      each of our NFT collections. This leaderboard will highlight and market
      the clubs that are the most active and supportive in our network. The aim
      is to boost purchases through the ICPFA shop.</p> <p class="my-2">In November 2023, a proposal was passed in the OpenChat DAO for them to
      become the official sponsor of OpenFPL. They will appear on our pick team
      advertising boards along with the football apparel given to grassroots
      football causes and sold through the ICPFA shop. We feel this partnership
      is important as promoting the wide arrange of apps available on the IC
      ecosytem will increase the pace at which the world adopts Internet
      Computer services.</p> <h2 class="text-lg font-bold mt-4">Future Considerations</h2> <p class="my-2">Outside of traditional digital marketing we plan to explore additional
      areas, such as influencer marketing.</p> <h2 class="text-xl font-bold">In-Person Event Marketing Strategy</h2> <p class="my-2">As part of our comprehensive marketing plan, OpenFPL is preparing to
      launch a series of in-person, interactive events in cities home to Premier
      League clubs. These events, expected to start from Q2 2024, are inspired
      by the successful engagement strategies of major UK brands like IBM, Ford
      and Coca-Cola.</p> <h2 class="text-lg font-bold mt-4">Event Planning and Execution</h2> <p class="my-2">We are in discussions with experienced interactive hardware providers and
      event management professionals to assist in creating immersive event
      experiences. We will utilise the expertise of OpenFPL founder, James
      Beadle, in developing and delivering these interactive experiences.</p> <h2 class="text-lg font-bold mt-4">Event Objectives and Content</h2> <p class="my-2">We would like to teach attendees about OpenFPL and the broader Internet
      Computer ecosystem, including Internet Identity and a variety of IC dApps.
      Facilitating hands-on interactions and demonstrations will provide a
      deeper understanding of OpenFPL&#39;s features and benefits.</p> <h2 class="text-lg font-bold mt-4">Promotion and Community Engagement</h2> <p class="my-2">We plan to promote these events through targeted local advertising, social
      media campaigns, and collaborations with local football clubs and
      communities. We will encouraging participants to share their experiences
      on social media through various reward scheme, amplifying our reach and
      impact.</p> <h2 class="text-lg font-bold mt-4">Long-Term Vision</h2> <p class="my-2">We will be exploring opportunities to replicate this event model in other
      regions, expanding OpenFPL&#39;s global footprint.</p> <h2 class="text-xl font-bold mt-4">Overall Approach</h2> <p class="my-2">The marketing plan aims to be dynamic, adapting to the evolving needs of
      OpenFPL and the response from the target audience. The digital agency and
      OpenFPL will work closely to ensure that the campaigns are coherent,
      data-driven, and aligned with OpenFPL’s overall branding and objectives.</p></div>`;return{c(){e=d("div"),e.innerHTML=a,this.h()},l(t){e=c(t,"DIV",{class:!0,"data-svelte-h":!0}),T(e)!=="svelte-1ntnimn"&&(e.innerHTML=a),this.h()},h(){n(e,"class","container-fluid mx-auto p-4")},m(t,s){y(t,e,s)},p:u,i:u,o:u,d(t){t&&r(e)}}}class lt extends _{constructor(e){super(),$(this,e,null,ot,O,{})}}function rt(i){let e,a=`<div class="m-4"><h1 class="text-3xl font-bold">OpenFPL Revenue Streams</h1> <p class="my-4">OpenFPL&#39;s revenue model is thoughtfully designed to sustain and grow the
      DAO while ensuring practical utility and value for its users.</p> <h2 class="text-lg font-bold">Diversified Revenue Model</h2> <p class="my-2">To avoid creating a supply shock by pegging services to a fixed token
      amount, OpenFPL&#39;s revenue streams are diversified. This approach mitigates
      the risk of reduced service usage due to infeasibility, ensuring long-term
      stability and utility.</p> <p class="my-2">Revenue streams include Private Leagues, Site Sponsorship, Content
      Creators, Podcasts, and Merchandise. These channels provide a balanced mix
      of $FPL and $ICP revenue, enhancing the DAO&#39;s financial resilience.</p> <h2 class="text-lg font-bold mt-4">Private Leagues</h2> <p class="my-2">Private league fees in OpenFPL are charged in ICP to establish a stable
      revenue base. This approach aligns the revenue directly with the number of
      managers, ensuring it scales with user engagement.</p> <h2 class="text-lg font-bold mt-4">Merchandise</h2> <p class="my-2">We have setup a shop at <a class="text-blue-500" href="https://icpga.org/shop">icpfa.org/shop</a> where you will be able to purchase OpenFPL merchandise in FPL or ICP. All
      profits after the promotion, marketing and production of this merchandise will
      be deposited into the DAO&#39;s treasury.</p> <h2 class="text-xl font-bold">Podcasts</h2> <p class="my-2">OpenFPL is expanding into podcasting with a main podcast and then various
      club-specific satellite podcasts. Initially hosted off-chain, our
      long-term goal is to transition these to on-chain hosting as services
      become available.</p> <p class="my-2">The main podcast will cover general OpenFPL and football topics, while the
      satellite podcasts will target fans of specific clubs.</p> <p class="my-2">Revenue will be generated from sponsorships and advertising. As our
      listener base grows, these podcasts are expected to become increasingly
      lucrative. All profits, after production costs, will be deposited into the
      DAO&#39;s treasury. Beyond revenue, these podcasts are a strategic move to
      bolster community engagement and enhance the OpenFPL brand, providing
      valuable content to our audience.</p> <h2 class="text-lg font-bold mt-4">Site Sponsorship</h2> <p class="my-2">Starting from August 2025, following the conclusion of the sponsorship
      deal with OpenChat, OpenFPL will offer the site sponsorship rights for
      bidding through the DAO. This will open opportunities for interested
      parties to become the named sponsor for an entire season.</p> <p class="my-2">Each year, sponsors can submit their bids to become the main site sponsor
      for the upcoming season, offering any ICRC-1 currency. Once a sponsor is
      selected, their exclusive rights will be secure for the entirety of that
      season. The DAO will not allow further proposals for site sponsorship
      until the subsequent preseason, ensuring the sponsor&#39;s exclusive
      visibility and association with OpenFPL.</p> <p class="my-2">All sponsorship revenue will be directed into the DAO&#39;s treasury,
      contributing to the financial health and sustainability of OpenFPL.</p> <h2 class="text-lg font-bold mt-4">Content Creators</h2> <p class="my-2">OpenFPL will create a platform for content creators that is designed to
      both empower creators and enhance the utility of the FPL token. Creators
      will produce fantasy football-related content and share it on OpenFPL.
      This content will be available through a video reel format accessible to
      all users.</p> <p class="my-2">For general reel content, creators earn from a pool of FPL tokens,
      allocated based on user likes. Creators can also offer exclusive content
      for subscribers. They will receive 95% of the FPL tokens from these
      subscriptions.</p> <p class="my-2">Subscriptions are purchased exclusively with FPL tokens, enhancing their
      utility. The remaining 5% from subscriptions remains in the DAO&#39;s
      treasury. This approach aligns with OpenFPL&#39;s commitment to supporting
      content creators, increasing FPL token utility, and rewarding its
      community of neuron holders.</p> <h2 class="text-lg font-bold mt-4">Revenue Redistribution Plan</h2> <p class="my-2">In line with our commitment to directly benefit neuron holders, OpenFPL
      will allocate 50% of any ICRC-1 token received by the DAO each month to
      neuron holders.</p> <p class="my-2">Distribution to neuron holders will be proportional to each neuron&#39;s total
      $FPL value and its remaining duration. This ensures a fair and equitable
      redistribution of revenue.</p> <p class="my-2">Calculation for this distribution will be based on the status of FPL
      neurons as at the end of each month, aligning with the DAO&#39;s transparent
      and community-focused ethos.</p> <h2 class="text-xl font-bold mt-4">Overall Revenue Philosophy</h2> <p class="my-2">OpenFPL’s revenue philosophy is rooted in creating a sustainable ecosystem
      where the utility token maintains its value and relevance.</p> <p class="my-2">The reinvestment of revenues into the DAO and direct distribution to
      neuron holders are designed to foster a cycle of growth, user engagement,
      and shared prosperity.</p></div>`;return{c(){e=d("div"),e.innerHTML=a,this.h()},l(t){e=c(t,"DIV",{class:!0,"data-svelte-h":!0}),T(e)!=="svelte-1fh4xy"&&(e.innerHTML=a),this.h()},h(){n(e,"class","container-fluid mx-auto p-4")},m(t,s){y(t,e,s)},p:u,i:u,o:u,d(t){t&&r(e)}}}class dt extends _{constructor(e){super(),$(this,e,null,rt,O,{})}}function ct(i){let e,a=`<div class="m-4"><h1 class="text-3xl font-bold">Roadmap</h1> <p class="my-4">We have an ambitious roadmap of features we aim to release:</p> <h2 class="text-lg font-bold">November 2023: Investment NFTs Launch</h2> <p class="my-2">We will be launching 2 NFT collections in November 2024 to give the
      opportunity for users to share in OpenFPL merchandise and podcast revenue.
      These NFTs will be used to fund the production of OpenFPL merchandise
      along with promotion of the OpenFPL platform in the run up to the genesis
      season. Further information can be found in the marketing section of this
      whitepaper.</p> <h2 class="text-lg font-bold mt-4">December 2023: Svelte Frontend Upgrade</h2> <p class="my-2">We&#39;re aligning OpenFPL with flagship IC apps like the NNS, OpenChat &amp; Juno
      by adopting Svelte. This upgrade ensures a consistent user experience and
      leverages Svelte’s server-side rendering for faster load times.</p> <h2 class="text-lg font-bold mt-4">Jan - Feb 2024: SNS Testflight Testing</h2> <p class="my-2">We will perform comprehensive testing of the OpenFPL gameplay and
      governance features. Detailed descriptions and outcomes of various use
      case tests, demonstrating how gameplay and governance features perform in
      different situations.</p> <h2 class="text-lg font-bold mt-4">January 2024: &#39;The OpenFPL Podcast&#39; Launch</h2> <p class="my-2">Starting with a main podcast, we aim to expand into fan-focused podcasts,
      emulating the model of successful platforms like Arsenal Fan TV. Initially
      audio-based, these podcasts will eventually include video content, adding
      another dimension to our engagement strategy.</p> <h2 class="text-lg font-bold mt-4">January 2024: Shirt Production Begins</h2> <p class="my-2">We are actively engaged in shirt production for OpenFPL, moving beyond
      mere concepts to tangible products. Our collaboration with a UK supplier
      is set to kit out 200 junior clubs with OpenFPL-branded shirts for
      charity, marking our first foray into merging style with the spirit of the
      game. This initiative is further elevated by a successful partnership with
      OpenChat. A recent proposal in the OpenChat DAO has been passed, resulting
      in OpenChat sponsoring half of these shirts, a testament to our
      collaborative efforts and shared vision. Concurrently, we are in advanced
      talks with a manufacturer in India, having already developed a promising
      prototype. We are fine-tuning the details to perfect the shirts, with
      production anticipated to commence in just a few months. Additionally,
      these shirts will be available for sale in the ICPFA shop, with a portion
      of each sale benefiting our NFT holders. This dual approach not only
      strengthens our brand presence but also underscores our commitment to
      supporting grassroots football communities and providing value to our NFT
      investors.</p> <h2 class="text-lg font-bold mt-4">February 2024: Online Marketing Campaigns</h2> <p class="my-2">We are actively in discussions with a digital marketing agency, preparing
      to launch campaigns aimed at organically growing our base of genuine
      managers. The strategy being formulated focuses on SEO and PPC methods
      aligned with OpenFPL&#39;s objectives. These deliberations include choosing
      the most suitable online platforms and crafting a strategy that resonates
      with our ethos. The direction of these campaigns is geared towards
      measurable outcomes, especially in attracting genuine manager sign-ups and
      naturally expanding our online footprint. This approach is designed to
      cultivate a genuine and engaged community, enhancing OpenFPL&#39;s presence in
      a manner that&#39;s both authentic and impactful.</p> <h2 class="text-lg font-bold mt-4">March 1st 2024: OpenFPL SNS Decentralisation Sale</h2> <p class="my-2">We aim to begin our decentralisation sale on 1st March 2024, selling 25
      million $FPL tokens (25%).</p> <h2 class="text-lg font-bold mt-4">April 2024: Private Leagues</h2> <p class="my-2">The Private Leagues feature is the start of building your own OpenFPL
      community within the DAO. Managers will be able to create a Private League
      for a fee of 1 $ICP. Managers will have full control over their rewards
      structure, with features such as: Deciding on the entry fee, if any. Any
      entry fee can be in $FPL, $ICP or ckBTC. Deciding on the rewards structure
      currency, amount and percentage payouts per finishing position.</p> <h2 class="text-lg font-bold mt-4">April 2024: OpenFPL Events</h2> <p class="my-2">OpenFPL is set to create a series of interactive experiences at event
      locations in Premier League club cities, drawing inspiration from major UK
      brands like IBM, Ford and Coca-Cola. Planned from Q2 2024 onwards, these
      events will leverage the expertise of OpenFPL founder James Beadle. With
      his experience in creating successful and engaging interactive
      experiences, James aims to play a key role in educating attendees about
      OpenFPL, Internet Identity and the range of other IC dApps available.</p> <h2 class="text-lg font-bold mt-4">July 2024: Mobile App Launch</h2> <p class="my-2">We will release a mobile app shortly before the genesis season begins to
      make OpenFPL more accessible and convenient for users on the go.</p> <h2 class="text-lg font-bold mt-4">August 2024: OpenFPL Genesis Season Begins</h2> <p class="my-2">In August 2024, we launch our inaugural season, where fantasy teams start
      competing for $FPL rewards on a weekly, monthly and annual basis to
      maximise user engagment.</p> <h2 class="text-lg font-bold mt-4">November 2024: Content Subscription Launch</h2> <p class="my-2">Partnering with Premier League content creators to offer exclusive
      insights, with a unique monetization model for both free and
      subscription-based content.</p> <h2 class="text-lg font-bold mt-4">March 2025: OpenChat Integration</h2> <p class="my-2">Integrating OpenChat for seamless communication within the OpenFPL
      community, providing updates and increasing engagement through group
      channels.</p> <h2 class="text-lg font-bold mt-4">Future: 100% On-Chain AI</h2> <p class="my-2">At OpenFPL, we are exploring the deployment of a 100% on-chain AI model
      within a dedicated canister. Our initial use case for this AI would be to
      integrate a feature within the team selection interface, allowing users to
      receive AI-recommended changes. Users will then have the option to review
      and decide whether to implement these AI suggestions in their team
      management decisions. However, given that the Internet Computer&#39;s
      infrastructure is still evolving, especially in terms of on-chain training
      capabilities, our immediate strategy involves training the model
      off-chain. As the IC infrastructure evolves we would look to transition to
      real-time, continual learning for the AI model directly on the IC. Looking
      ahead, we&#39;re excited about the potential to develop new models using our
      constantly expanding on-chain dataset, opening up more innovative
      possibilities for OpenFPL.</p></div>`;return{c(){e=d("div"),e.innerHTML=a,this.h()},l(t){e=c(t,"DIV",{class:!0,"data-svelte-h":!0}),T(e)!=="svelte-xjct59"&&(e.innerHTML=a),this.h()},h(){n(e,"class","container-fluid mx-auto p-4")},m(t,s){y(t,e,s)},p:u,i:u,o:u,d(t){t&&r(e)}}}class ht extends _{constructor(e){super(),$(this,e,null,ct,O,{})}}function pt(i){let e,a=`<div class="m-4"><h1 class="text-3xl font-bold my-4">$FPL Utility Token</h1> <h2 class="text-xl font-bold">Utility and Functionality</h2> <p class="my-2">OpenFPL will be revenue generating, the most important role of the Utility
      token is to manage the OpenFPL treasury. The token is also used throughout
      the OpenFPL ecosystem:</p> <ul class="list-disc ml-4"><li>Rewarding users for gameplay achievements on weekly, monthly, and annual
        bases.</li> <li>Facilitating participation in DAO governance, like raising proposals for
        player revaluation and team detail updates.</li> <li>Rewarding neuron holders upon maturity.</li> <li>Accepting bids for season site sponsorship from organisations.</li> <li>Used for customisable entry fee (along with any ICRC-1 token)
        requirements for private leagues.</li> <li>Purchase of Merchandise from the ICPFA shop.</li> <li>Reward content creators for engagement on a football video reel.</li> <li>Facilitate subscriptions to access premium football content from
        creators.</li></ul> <h2 class="text-lg font-bold mt-4">Genesis Token Allocation</h2> <p class="my-2">At the outset, OpenFPL&#39;s token allocation will be as follows:</p> <ul class="list-disc ml-4"><li>ICPFA: 12%</li> <li>Funded NFT Holders: 12%</li> <li>SNS Decentralisation Sale: 25%</li> <li>DAO Treasury: 51%</li></ul> <p class="my-2">The ICPFA team members will receive their $FPL within 5 baskets of equal
      neurons. The neurons will contain the following configuration:</p> <ul class="list-disc ml-4"><li>Basket 1: Locked for 3 months with a 3 month dissolve delay.</li> <li>Basket 2: Locked for 6 months with a 3 month dissolve delay.</li> <li>Basket 3: Locked for 12 months with a 3 month dissolve delay.</li> <li>Basket 4: Locked for 18 months with a 3 month dissolve delay.</li> <li>Basket 5: Locked for 24 months with a 3 month dissolve delay.</li></ul> <p class="my-2">Each Funded NFT holder will receive their $FPL within 5 baskets of equal
      neurons. The neurons will contain the following configuration:</p> <ul class="list-disc ml-4"><li>Basket 1: Unlocked with a dissolve delay of 30 days.</li> <li>Basket 2: Locked for 6 months with a 1 month dissolve delay.</li> <li>Basket 3: Locked for 12 months with a 1 month dissolve delay.</li> <li>Basket 4: Locked for 18 months with a 1 month dissolve delay.</li> <li>Basket 5: Locked for 24 months with a 1 month dissolve delay.</li></ul> <p class="my-2">Each SNS decentralisation swap participant will receive their $FPL within
      5 baskets of equal neurons. The neurons will contain the following
      configuration:</p> <ul class="list-disc ml-4"><li>Basket 1: Unlocked with zero dissolve delay.</li> <li>Basket 2: Unlocked with 3 months dissolve delay.</li> <li>Basket 3: Unlocked with 6 months dissolve delay.</li> <li>Basket 4: Unlocked with 9 months dissolve delay.</li> <li>Basket 5: Unlocked with 12 months dissolve delay.</li></ul> <h2 class="text-lg font-bold mt-4">DAO Valuation</h2> <p class="my-2">We have used the discounted cashflow method to value the DAO. The
      following assumptions have been made:</p> <ul class="list-disc ml-4"><li>We can grow to the size of our Web2 competitor over 8 years.</li> <li>Assumed 10% user conversion, each setting up a league at 1 ICP.</li> <li>Estimated 5% user content subscription rate at 5 ICP/month with 5% of
        this revenue going to the DAO.</li> <li>Estimated 5% users spend 10ICP per year.</li></ul> <p class="mt-8">The financials below are in ICP:</p> <table class="w-full text-right border-collapse striped mb-8 mt-4 svelte-58jp75"><tr class="text-right svelte-58jp75"><th class="text-left px-4">Year</th> <th>1</th> <th>2</th> <th>3</th> <th>4</th> <th>5</th> <th>6</th> <th>7</th> <th>8</th></tr> <tr class="svelte-58jp75"><td class="h-6"><span></span></td></tr> <tr class="svelte-58jp75"><td class="text-left px-4">Managers</td> <td>10,000</td> <td>50,000</td> <td>250,000</td> <td>1,000,000</td> <td>2,500,000</td> <td>5,000,000</td> <td>7,500,000</td> <td>10,000,000</td></tr> <tr class="svelte-58jp75"><td class="h-6"><span></span></td></tr> <tr class="svelte-58jp75"><td class="text-left px-4" colspan="9">Revenue:</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4">Private Leagues</td> <td>1,000</td> <td>5,000</td> <td>25,000</td> <td>100,000</td> <td>250,000</td> <td>500,000</td> <td>750,000</td> <td>1,000,000</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4">Merchandising</td> <td>5,000</td> <td>25,000</td> <td>125,000</td> <td>500,000</td> <td>1,250,000</td> <td>2,500,000</td> <td>3,750,000</td> <td>5,000,000</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4">Content Subscriptions</td> <td>125</td> <td>625</td> <td>3,125</td> <td>12,500</td> <td>31,250</td> <td>62,500</td> <td>93,750</td> <td>125,000</td></tr> <tr class="svelte-58jp75"><td colspan="9" class="h-6"><span></span></td></tr> <tr class="font-bold svelte-58jp75"><td class="text-left px-4">Total</td> <td>6,125</td> <td>30,625</td> <td>153,125</td> <td>612,500</td> <td>1,531,250</td> <td>3,062,500</td> <td>4,593,750</td> <td>6,125,000</td></tr> <tr class="svelte-58jp75"><td colspan="9" class="h-6"><span></span></td></tr> <tr class="font-bold svelte-58jp75"><td class="text-left px-4" colspan="8">SNS Value (25%)</td> <td>1,531,250</td></tr></table> <h2 class="text-lg font-bold mt-4">SNS Decentralisation Sale Configuration</h2> <table class="w-full text-left border-collapse striped mb-8 mt-4 svelte-58jp75"><tr class="svelte-58jp75"><th>Configuration</th> <th>Value</th></tr> <tr class="svelte-58jp75"><td class="h-6"><span></span></td></tr> <tr class="svelte-58jp75"><td>The total number of FPL tokens to be sold.</td> <td>25,000,000 (25%)</td></tr> <tr class="svelte-58jp75"><td>The maximum ICP to be raised.</td> <td>2,000,000</td></tr> <tr class="svelte-58jp75"><td>The minimum ICP to be raised (otherwise sale fails and ICP returned).</td> <td>1,000,000</td></tr> <tr class="svelte-58jp75"><td>The ICP from the Community Fund.</td> <td>Matched Funding Enabled</td></tr> <tr class="svelte-58jp75"><td>Sale start date.</td> <td>1st March 2024</td></tr> <tr class="svelte-58jp75"><td>Minimum number of sale participants.</td> <td>500</td></tr> <tr class="svelte-58jp75"><td>Minimum ICP per buyer.</td> <td>10</td></tr> <tr class="svelte-58jp75"><td>Maximum ICP per buyer.</td> <td>150,000</td></tr></table> <h2 class="text-lg font-bold mt-4">Mitigation against a 51% Attack</h2> <p class="my-2">There is a danger that the OpenFPL SNS treasury could be the target of an
      attack. One possible scenario is for an attacker to buy a large proportion
      of the FPL tokens in the decentralisation sale and immediately increase
      the dissolve delay of all of their neurons to the maximum 4 year in an
      attempt to gain more than 50% of the SNS voting power. If successful they
      could force through a proposal to transfer the entire ICP and FPL treasury
      to themselves. The Community Fund actually provides a great deal of
      mitigation against this scenario because it limits the proportion of
      voting power an attacker would be able to acquire.</p> <p class="my-2">The amount raised in the decentralisation will be used as follows:</p> <ul class="list-disc ml-4"><li>80% will be staked in an 8 year neuron with the maturity interest paid
        to the ICPFA.</li> <li>10% will be available for exchange liquidity to enable trading of the
        FPL token.</li> <li>5% will be paid directly to the ICPFA after the decentralisation sale.</li> <li>5% will be held in reserve for cycles to run OpenFPL, likely to be
        unused as OpenFPL begins generating revenue.</li></ul> <p class="my-2">This treasury balance will be topped up with the DAO&#39;s revenue, with 50%
      being paid to neuron holders. Any excess balance can be utilised where the
      DAO sees fit.</p> <h2 class="text-lg font-bold mt-4">Tokenomics</h2> <p class="my-2">Each season, 2.5% of the total $FPL supply will be minted for DAO rewards.
      There is no mechanism to automatically burn $FPL as we anticipate the user
      growth to be faster than the supply increase, thus increasing the price of
      $FPL. However a proposal can always be made to burn $FPL if required. If
      the DAO’s treasury is ever 60% or more of the total supply of $FPL, it
      will be ICP FA policy to raise a proposal to burn 5% of the total supply
      from the DAO’s treasury.</p> <h2 class="text-lg font-bold mt-4">ICP FA Overview</h2> <p class="my-2">Managed by founder James Beadle, the ICP FA oversees the development,
      marketing, and management of OpenFPL. The aim is to build a strong team to
      guide OpenFPL&#39;s growth and bring new users to the ICP blockchain.
      Additionally, 25% of James&#39; staked maturity earnings will contribute to
      the ICP FA Community Fund, supporting grassroots football projects.</p> <p class="my-2">The ICPFA will receive 5% of the decentralisation sale along with the
      maturity interest from the staked neuron. These funds will be use for the
      following:</p> <ul class="list-disc ml-4"><li>The ongoing promotion and marketing of OpenFPL both online and offline.</li> <li>Hiring of a frontend and backend developer to assist the founder with
        the day to day development workload.</li> <li>Hiring of a UAT Test Engineer to ensure all ICPFA products are of the
        highest quality.</li> <li>Hiring of a Marketing Manager.</li></ul> <p class="my-2">Along with paying the founding team members:</p> <ul class="list-disc ml-4"><li>James Beadle - Founder, Lead Developer</li> <li>DfinityDesigner - Designer</li> <li>George - Community Manager</li> <li>ICP_Insider - Blockchain Promoter</li> <li>MadMaxIC - Gameplay Designer</li></ul> <p class="my-2">More details about the ICP FA and its members can be found at <a class="text-blue-500" href="https://icpfa.org/team">icpfa.org/team</a>.</p></div>`;return{c(){e=d("div"),e.innerHTML=a,this.h()},l(t){e=c(t,"DIV",{class:!0,"data-svelte-h":!0}),T(e)!=="svelte-n2l67y"&&(e.innerHTML=a),this.h()},h(){n(e,"class","container-fluid mx-auto p-4")},m(t,s){y(t,e,s)},p:u,i:u,o:u,d(t){t&&r(e)}}}class ut extends _{constructor(e){super(),$(this,e,null,pt,O,{})}}function mt(i){let e,a=`<div class="m-4"><h1 class="text-3xl font-bold">Our Vision</h1> <p class="my-4">In an evolving landscape where blockchain technology is still unlocking
      its potential, the Internet Computer offers a promising platform for
      innovative applications. OpenFPL is one such initiative, aiming to
      transform fantasy Premier League football into a more engaging and
      decentralised experience.</p> <p class="my-4">Our goal is to develop this popular service into a decentralised
      autonomous organisation (DAO), rewarding fans for their insight and
      participation in football.</p> <p class="my-4">Our vision for OpenFPL encompasses a commitment to societal impact,
      specifically through meaningful contributions to the ICPFA community fund.
      This effort is focused on supporting grassroots football initiatives,
      demonstrating our belief in OpenFPL&#39;s ability to bring about positive
      change in the football community.</p> <p class="my-4">OpenFPL aims to be recognised as more than just a digital platform; we
      aspire to build a brand that creates diverse revenue opportunities. Our
      economic model is designed to directly benefit our token holders,
      particularly those with staked neurons, through a fair distribution of
      rewards. This ensures that the value generated by the platform is shared
      within our community.</p> <p class="my-4">Central to OpenFPL is our community focus. We strive to create a space
      where Premier League fans feel at home, with their input shaping the
      service. Our features, including community-based player valuations,
      customisable private leagues, and collaborations with football content
      creators, are all aimed at enhancing user engagement. As we attract more
      users, we expect an increased demand for our services, which will
      contribute to the growth and value of our governance token, $FPL.</p> <p class="my-4">In essence, OpenFPL represents a unique blend of football passion and
      blockchain innovation. Our approach is about more than just reinventing
      fantasy sports; it&#39;s about building a vibrant community, pushing
      technological boundaries, and generating new economic opportunities.
      OpenFPL seeks to redefine the way fans engage with the sport they love,
      making a real impact in the football world.</p> <p class="my-4">Innovation is at the heart of OpenFPL. We are excited about exploring the
      possibilities of integrating on-chain AI to assist managers with team
      selection. This endeavor is not just about enhancing the user experience;
      it&#39;s about exploring new frontiers for blockchain technology in sports.</p></div>`;return{c(){e=d("div"),e.innerHTML=a,this.h()},l(t){e=c(t,"DIV",{class:!0,"data-svelte-h":!0}),T(e)!=="svelte-h0e58x"&&(e.innerHTML=a),this.h()},h(){n(e,"class","container-fluid mx-auto p-4")},m(t,s){y(t,e,s)},p:u,i:u,o:u,d(t){t&&r(e)}}}class ft extends _{constructor(e){super(),$(this,e,null,mt,O,{})}}function gt(i){let e,a;return e=new tt({}),{c(){C(e.$$.fragment)},l(t){A(e.$$.fragment,t)},m(t,s){I(e,t,s),a=!0},i(t){a||(w(e.$$.fragment,t),a=!0)},o(t){x(e.$$.fragment,t),a=!1},d(t){D(e,t)}}}function bt(i){let e,a;return e=new ut({}),{c(){C(e.$$.fragment)},l(t){A(e.$$.fragment,t)},m(t,s){I(e,t,s),a=!0},i(t){a||(w(e.$$.fragment,t),a=!0)},o(t){x(e.$$.fragment,t),a=!1},d(t){D(e,t)}}}function vt(i){let e,a;return e=new st({}),{c(){C(e.$$.fragment)},l(t){A(e.$$.fragment,t)},m(t,s){I(e,t,s),a=!0},i(t){a||(w(e.$$.fragment,t),a=!0)},o(t){x(e.$$.fragment,t),a=!1},d(t){D(e,t)}}}function yt(i){let e,a;return e=new dt({}),{c(){C(e.$$.fragment)},l(t){A(e.$$.fragment,t)},m(t,s){I(e,t,s),a=!0},i(t){a||(w(e.$$.fragment,t),a=!0)},o(t){x(e.$$.fragment,t),a=!1},d(t){D(e,t)}}}function wt(i){let e,a;return e=new lt({}),{c(){C(e.$$.fragment)},l(t){A(e.$$.fragment,t)},m(t,s){I(e,t,s),a=!0},i(t){a||(w(e.$$.fragment,t),a=!0)},o(t){x(e.$$.fragment,t),a=!1},d(t){D(e,t)}}}function xt(i){let e,a;return e=new ht({}),{c(){C(e.$$.fragment)},l(t){A(e.$$.fragment,t)},m(t,s){I(e,t,s),a=!0},i(t){a||(w(e.$$.fragment,t),a=!0)},o(t){x(e.$$.fragment,t),a=!1},d(t){D(e,t)}}}function kt(i){let e,a;return e=new nt({}),{c(){C(e.$$.fragment)},l(t){A(e.$$.fragment,t)},m(t,s){I(e,t,s),a=!0},i(t){a||(w(e.$$.fragment,t),a=!0)},o(t){x(e.$$.fragment,t),a=!1},d(t){D(e,t)}}}function Pt(i){let e,a;return e=new ft({}),{c(){C(e.$$.fragment)},l(t){A(e.$$.fragment,t)},m(t,s){I(e,t,s),a=!0},i(t){a||(w(e.$$.fragment,t),a=!0)},o(t){x(e.$$.fragment,t),a=!1},d(t){D(e,t)}}}function Lt(i){let e,a='<h1 class="p-4 mx-1 text-2xl">OpenFPL Whitepaper</h1>',t,s,p,j,P,ee,Y,Z,te,M,k,ge,ae,se,be,q,S,ve,ie,ne,ye,V,E,we,oe,le,xe,J,B,ke,re,de,Pe,z,R,Le,ce,he,Fe,K,W,Oe,pe,ue,Te,X,H,_e,me,fe,$e,v,b,m,Ce,Ae;const Ie=[Pt,kt,xt,wt,yt,vt,bt,gt],Q=[];function De(o,h){return o[0]==="vision"?0:o[0]==="gameplay"?1:o[0]==="roadmap"?2:o[0]==="marketing"?3:o[0]==="revenue"?4:o[0]==="dao"?5:o[0]==="tokenomics"?6:o[0]==="architecture"?7:-1}return~(v=De(i))&&(b=Q[v]=Ie[v](i)),{c(){e=d("div"),e.innerHTML=a,t=L(),s=d("div"),p=d("ul"),j=d("li"),P=d("button"),ee=N("Vision"),te=L(),M=d("li"),k=d("button"),ge=N("Gameplay"),be=L(),q=d("li"),S=d("button"),ve=N("Roadmap"),ye=L(),V=d("li"),E=d("button"),we=N("Marketing"),xe=L(),J=d("li"),B=d("button"),ke=N("Revenue"),Pe=L(),z=d("li"),R=d("button"),Le=N("DAO"),Fe=L(),K=d("li"),W=d("button"),Oe=N("Tokenomics"),Te=L(),X=d("li"),H=d("button"),_e=N("Architecture"),$e=L(),b&&b.c(),this.h()},l(o){e=c(o,"DIV",{class:!0,"data-svelte-h":!0}),T(e)!=="svelte-1qhfoq3"&&(e.innerHTML=a),t=F(o),s=c(o,"DIV",{class:!0});var h=g(s);p=c(h,"UL",{class:!0});var f=g(p);j=c(f,"LI",{class:!0});var je=g(j);P=c(je,"BUTTON",{class:!0});var Me=g(P);ee=U(Me,"Vision"),Me.forEach(r),je.forEach(r),te=F(f),M=c(f,"LI",{class:!0});var Se=g(M);k=c(Se,"BUTTON",{class:!0});var Ee=g(k);ge=U(Ee,"Gameplay"),Ee.forEach(r),Se.forEach(r),be=F(f),q=c(f,"LI",{class:!0});var Be=g(q);S=c(Be,"BUTTON",{class:!0});var Re=g(S);ve=U(Re,"Roadmap"),Re.forEach(r),Be.forEach(r),ye=F(f),V=c(f,"LI",{class:!0});var We=g(V);E=c(We,"BUTTON",{class:!0});var He=g(E);we=U(He,"Marketing"),He.forEach(r),We.forEach(r),xe=F(f),J=c(f,"LI",{class:!0});var Ne=g(J);B=c(Ne,"BUTTON",{class:!0});var Ue=g(B);ke=U(Ue,"Revenue"),Ue.forEach(r),Ne.forEach(r),Pe=F(f),z=c(f,"LI",{class:!0});var Ge=g(z);R=c(Ge,"BUTTON",{class:!0});var qe=g(R);Le=U(qe,"DAO"),qe.forEach(r),Ge.forEach(r),Fe=F(f),K=c(f,"LI",{class:!0});var Ve=g(K);W=c(Ve,"BUTTON",{class:!0});var Je=g(W);Oe=U(Je,"Tokenomics"),Je.forEach(r),Ve.forEach(r),Te=F(f),X=c(f,"LI",{class:!0});var ze=g(X);H=c(ze,"BUTTON",{class:!0});var Ke=g(H);_e=U(Ke,"Architecture"),Ke.forEach(r),ze.forEach(r),f.forEach(r),$e=F(h),b&&b.l(h),h.forEach(r),this.h()},h(){n(e,"class","bg-panel rounded-lg mx-4 mt-4"),n(P,"class",Y=`p-2 ${i[0]==="vision"?"text-white":"text-gray-400"}`),n(j,"class",Z=`mr-4 text-xs md:text-base ${i[0]==="vision"?"active-tab":""}`),n(k,"class",ae=`p-2 ${i[0]==="gameplay"?"text-white":"text-gray-400"}`),n(M,"class",se=`mr-4 text-xs md:text-base ${i[0]==="gameplay"?"active-tab":""}`),n(S,"class",ie=`p-2 ${i[0]==="roadmap"?"text-white":"text-gray-400"}`),n(q,"class",ne=`mr-4 text-xs md:text-base ${i[0]==="roadmap"?"active-tab":""}`),n(E,"class",oe=`p-2 ${i[0]==="marketing"?"text-white":"text-gray-400"}`),n(V,"class",le=`mr-4 text-xs md:text-base ${i[0]==="marketing"?"active-tab":""}`),n(B,"class",re=`p-2 ${i[0]==="revenue"?"text-white":"text-gray-400"}`),n(J,"class",de=`mr-4 text-xs md:text-base ${i[0]==="revenue"?"active-tab":""}`),n(R,"class",ce=`p-2 ${i[0]==="dao"?"text-white":"text-gray-400"}`),n(z,"class",he=`mr-4 text-xs md:text-base ${i[0]==="dao"?"active-tab":""}`),n(W,"class",pe=`p-2 ${i[0]==="tokenomics"?"text-white":"text-gray-400"}`),n(K,"class",ue=`mr-4 text-xs md:text-base ${i[0]==="tokenomics"?"active-tab":""}`),n(H,"class",me=`p-2 ${i[0]==="architecture"?"text-white":"text-gray-400"}`),n(X,"class",fe=`mr-4 text-xs md:text-base ${i[0]==="architecture"?"active-tab":""}`),n(p,"class","flex rounded-t-lg bg-light-gray px-4 pt-2"),n(s,"class","bg-panel rounded-lg m-4")},m(o,h){y(o,e,h),y(o,t,h),y(o,s,h),l(s,p),l(p,j),l(j,P),l(P,ee),l(p,te),l(p,M),l(M,k),l(k,ge),l(p,be),l(p,q),l(q,S),l(S,ve),l(p,ye),l(p,V),l(V,E),l(E,we),l(p,xe),l(p,J),l(J,B),l(B,ke),l(p,Pe),l(p,z),l(z,R),l(R,Le),l(p,Fe),l(p,K),l(K,W),l(W,Oe),l(p,Te),l(p,X),l(X,H),l(H,_e),l(s,$e),~v&&Q[v].m(s,null),m=!0,Ce||(Ae=[G(P,"click",i[2]),G(k,"click",i[3]),G(S,"click",i[4]),G(E,"click",i[5]),G(B,"click",i[6]),G(R,"click",i[7]),G(W,"click",i[8]),G(H,"click",i[9])],Ce=!0)},p(o,h){(!m||h&1&&Y!==(Y=`p-2 ${o[0]==="vision"?"text-white":"text-gray-400"}`))&&n(P,"class",Y),(!m||h&1&&Z!==(Z=`mr-4 text-xs md:text-base ${o[0]==="vision"?"active-tab":""}`))&&n(j,"class",Z),(!m||h&1&&ae!==(ae=`p-2 ${o[0]==="gameplay"?"text-white":"text-gray-400"}`))&&n(k,"class",ae),(!m||h&1&&se!==(se=`mr-4 text-xs md:text-base ${o[0]==="gameplay"?"active-tab":""}`))&&n(M,"class",se),(!m||h&1&&ie!==(ie=`p-2 ${o[0]==="roadmap"?"text-white":"text-gray-400"}`))&&n(S,"class",ie),(!m||h&1&&ne!==(ne=`mr-4 text-xs md:text-base ${o[0]==="roadmap"?"active-tab":""}`))&&n(q,"class",ne),(!m||h&1&&oe!==(oe=`p-2 ${o[0]==="marketing"?"text-white":"text-gray-400"}`))&&n(E,"class",oe),(!m||h&1&&le!==(le=`mr-4 text-xs md:text-base ${o[0]==="marketing"?"active-tab":""}`))&&n(V,"class",le),(!m||h&1&&re!==(re=`p-2 ${o[0]==="revenue"?"text-white":"text-gray-400"}`))&&n(B,"class",re),(!m||h&1&&de!==(de=`mr-4 text-xs md:text-base ${o[0]==="revenue"?"active-tab":""}`))&&n(J,"class",de),(!m||h&1&&ce!==(ce=`p-2 ${o[0]==="dao"?"text-white":"text-gray-400"}`))&&n(R,"class",ce),(!m||h&1&&he!==(he=`mr-4 text-xs md:text-base ${o[0]==="dao"?"active-tab":""}`))&&n(z,"class",he),(!m||h&1&&pe!==(pe=`p-2 ${o[0]==="tokenomics"?"text-white":"text-gray-400"}`))&&n(W,"class",pe),(!m||h&1&&ue!==(ue=`mr-4 text-xs md:text-base ${o[0]==="tokenomics"?"active-tab":""}`))&&n(K,"class",ue),(!m||h&1&&me!==(me=`p-2 ${o[0]==="architecture"?"text-white":"text-gray-400"}`))&&n(H,"class",me),(!m||h&1&&fe!==(fe=`mr-4 text-xs md:text-base ${o[0]==="architecture"?"active-tab":""}`))&&n(X,"class",fe);let f=v;v=De(o),v!==f&&(b&&(Qe(),x(Q[f],1,1,()=>{Q[f]=null}),Ye()),~v?(b=Q[v],b||(b=Q[v]=Ie[v](o),b.c()),w(b,1),b.m(s,null)):b=null)},i(o){m||(w(b),m=!0)},o(o){x(b),m=!1},d(o){o&&(r(e),r(t),r(s)),~v&&Q[v].d(),Ce=!1,Xe(Ae)}}}function Ft(i){let e,a;return e=new Ze({props:{$$slots:{default:[Lt]},$$scope:{ctx:i}}}),{c(){C(e.$$.fragment)},l(t){A(e.$$.fragment,t)},m(t,s){I(e,t,s),a=!0},p(t,[s]){const p={};s&1025&&(p.$$scope={dirty:s,ctx:t}),e.$set(p)},i(t){a||(w(e.$$.fragment,t),a=!0)},o(t){x(e.$$.fragment,t),a=!1},d(t){D(e,t)}}}function Ot(i,e,a){let t="vision";function s(k){a(0,t=k)}return[t,s,()=>s("vision"),()=>s("gameplay"),()=>s("roadmap"),()=>s("marketing"),()=>s("revenue"),()=>s("dao"),()=>s("tokenomics"),()=>s("architecture")]}class Ct extends _{constructor(e){super(),$(this,e,Ot,Ft,O,{})}}export{Ct as component};

import React from 'react';

const Architecture = () => {
  
  return (
    <div className="w-100 px-3">

        <h3 className='mb-4'>Architecture</h3>
        <p className='mb-4'>OpenFPL is being built as a progressive web application, it's curernt frontend is React but will be moved over to Svelte for the start of 2024. The OpenFPL backend is developed in Motoko.
            The Github is publicly available at github.com/jamesbeadle/openfpl.
            OpenFPL's architecture is designed for scalability and efficiency, ensuring robust performance even as user numbers grow. Here's how the system is structured:</p>
        
        <h5>Profile Data</h5>
        
        <p>OpenFPL allocates approximately 254 bytes for a profile record. This means that a single Profile Canister could hold more than 16m profiles, scaling to a size larger than the market leader.</p>
        <p className='mb-4'>Each profile record will hold a reference to the Profile Picture canister where their pfp is stored. We limit the size of profile pictures to 500KB, meaning you can store 8,000 images per Profile Picture canister. When the canister is full, a new Profile Picture canister is created to store the images.</p>        

        <h5>Fantasy Teams Data</h5>
        
        <p className='mb-4'>OpenFPL allocates approximately 913 KB for a fantasy team with a lifetime of seasons history. 
            Therefore we can store over 4,000 fantasy teams in each canister. 
            When this limit is reached, a new canister is created. A reference to the user’s Fantasy Team canister is stored in the user profile record.</p>

        <h5>Leaderboard Data</h5>
        <p className='mb-4'>The size of the leaderboard data is very much dependent on the number of users on the site as each will create an entry in each leaderboard. 
            Therefore we will create a new canister for each leaderboard. 
            For each season there will be a Season Leaderboard canister, 38 Gameweek Leaderboard canisters and 12 Monthly Leaderboard canisters. 
            This architecture will scale to 25m+ users, more than double the players of the market leading platform. </p>

        <h5>Main Canister & Central Data Management</h5>

        <p>Our system estimates the size of the main canister containing data for 100 seasons as around 44MB. 
            With around 1% of the 4GB canister being used, substantial room is available for additional growth and functionalities. 
            The Main canister will contain the following key pieces of information:</p>

        <ul className='mb-4'>
            <li>Data Cache Hashes</li>
            <li>Teams Data</li>
            <li>Seasons Data</li>
            <li>Canister References</li>
        </ul>

        <h5>Player Canisters</h5>

        <p>The player canisters container information on all Premier League football players. OpenFPL allocates approximately 30 KB for each Player record. 
        With a single canister on the Internet Computer boasting a 4GB capacity, it will be able to store 100.000+ Premier League player entries. 
        Each Premier League team could theoretically introduce up to 50 new players per team annually. 
        However, this number implies a complete change of a team's squad, an eventuality that's exceedingly uncommon in the Premier League. 
        Therefore, our projection of 1,000 new players across the league each year offers a deliberately conservative overestimation. 
        Given these calculations, the following 3 canisters will be able to manage all the Premier League players for well over 100 years:</p>        

        <ul>
            <li>Live Players Canister</li>
            <li>Former Players Canister</li>
            <li>Retired Players Canister</li>
        </ul>

        <p className='mb-4'>Players will move from the live canister to and from the Former or Retired players canister when required.</p>

        <h5>Cycle Dispenser</h5>

        <p className='mb-4'>The cycle dispenser canister watches each canister in the OpenFPL ecosystem and tops it up with cycles when it reaches 20% of its top up value.</p>

        <h4>Note on Architecture Evolution and Whitepaper Updates</h4>

        <p>As OpenFPL progresses through the SNS testflight phase, our architecture may undergo changes to optimize performance and scalability. 
            We are committed to staying at the forefront of technological advancements, ensuring that our platform remains robust and efficient.</p>

        <p className='mb-4'>To keep our community and stakeholders informed, any significant changes to the architecture will be reflected in updated versions of this whitepaper. 
            Each new version will be clearly marked to ensure transparency and ease of reference, maintaining our commitment to openness and communication with our users.</p>

    </div>
  );
};

export default Architecture;

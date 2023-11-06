import React from 'react';

const DAO = () => {
  
  return (
    <div className="w-100">

        <h1>OpenFPL DAO</h1>

        <h5>Operating Framework</h5>
        <p>OpenFPL functions entirely on-chain as a DAO, aspiring to operate under the Internet Computer’s Service Nervous System. 
            The DAO is structured to run in parallel with the Premier League season, relying on input from its neuron holders who are rewarded for maintaining independence from third-party services.</p>
        
        <h5>DAO Reward Structure</h5>

        <p>The DAO incentivizes participation through monthly minting of new FPL tokens, calculated annually as 2.5% of the total $FPL supply as of August 1st. These tokens are allocated to:</p>
        <ul>
            <li>Gameplay Rewards (75%)</li>
            <li>Governance Rewards (25%)</li>
        </ul>

        <h5>Gameplay Rewards (75%)</h5>

        <p>The DAO is designed to reward users for their expertise in fantasy football, with rewards distributed weekly, monthly, and annually based on performance. 
            The rewards are tiered to encourage ongoing engagement. Here’s the breakdown:</p>

        <ul>
            <li>Global Season Leaderboard Rewards: 30% for the top 100 global season positions.</li>
            <li>Club Monthly Leaderboard Rewards: 20% for the top 100 in each monthly club leaderboard, adjusted for the number of fans in each club.</li>
            <li>Global Weekly Leaderboard Rewards: 15% for the top 100 weekly positions.</li>
            <li>Most Valuable Team Rewards: 10% for the top 100 most valuable teams at season's end.</li>
            <li>Highest Scoring Match Player Rewards: 10% split among managers selecting the highest-scoring player in a fixture.</li>
            <li>Weekly/Monthly/Season ATH Score Rewards: 5% each, reserved for breaking all-time high scores in respective categories.</li>
        </ul>       

        <p>To ensure rewards are paid for active participation, a user would need to do the following to qualify for the following OpenFPL gameplay rewards:</p>

        <ul>
            <li>A user must have made at least 2 changes in a month to qualify for that month's club leaderboard rewards and monthly ATH record rewards.</li>
            <li>A user must have made at least 1 change in a gameweek to qualify for that week's leaderboard rewards, highest-scoring match player rewards and weekly ATH record rewards.</li>
            <li>Rewards for the season total, most valuable team have and annual ATH have no entry restrictions as it is based on the cumulative action of managers transfers throughout the season.</li>
        </ul>       

        <h5>Governance Rewards (25%)</h5>

        <ul>
            <li>OpenFPL values neuron holders' contributions to maintaining up-to-date Premier League data. 
                Rewards are given for raising and voting on essential proposals, such as scheduling, player transfers, and updating player information. 
                Failed proposals incur a 10 $FPL cost, contributing to the DAO’s treasury.</li>
        </ul>

        <p>The OpenFPL DAO is an innovative approach to fantasy football, combining real-time data accuracy with rewarding community involvement. 
            By aligning rewards with active participation, OpenFPL ensures a vibrant, informed, and engaged user base.</p>


    </div>
  );
};

export default DAO;

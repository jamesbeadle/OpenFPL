import React from 'react';

const Token = () => {
  
  return (
    <div className="w-100">

        <h1>$FPL Utility Token</h1>
        
        <h1>Utility and Functionality</h1>
        
        <p>OpenFPL will be revenue generating, the most important role of the Utility token is to manage the OpenFPL treasury. 
            The token is also used throughout the OpenFPL ecosystem:</p>
        <p>
            The $FPL utility token is integral to the OpenFPL ecosystem, serving multiple purposes:
        </p>
        
        <ul>
            <li>Rewarding users for gameplay achievements on weekly, monthly, and annual bases.</li>
            <li>Facilitating participation in DAO governance, like raising proposals for player revaluation and team detail updates.</li>
            <li>Rewarding neuron holders upon maturity.</li>
            <li>Accepting bids for season site sponsorship from organisations.</li>
            <li>Used for customisable entry fee (along with any ICRC-1 token) requirements for private leagues.</li>
            <li>Purchase of Merchandise from the ICPFA shop.</li>
            <li>Reward content creators for engagement on a football video reel.</li>
            <li>Facilitate subscriptions to access premium football content from creators.</li>
        </ul>

        <h5>Genesis Token Allocation</h5>

        <p>At the outset, OpenFPL's token allocation will be as follows:</p>
        <ul>
            <li>ICP FA: 12%</li>
            <li>Funded NFT Holders: 12%</li>
            <li>SNS Decentralisation Sale: 25%</li>
            <li>DAO Treasury: 51%</li>
        </ul>

        <p>The ICPFA team members will receive their $FPL within 5 baskets of equal neurons. The neurons will contain the following configuration:
        </p>
        <ul>
            <li>Basket 1: Locked for 3 months with a 3 month dissolve delay.</li>
            <li>Basket 2: Locked for 6 months with a 3 month dissolve delay.</li>
            <li>Basket 3: Locked for 12 months with a 3 month dissolve delay.</li>
            <li>Basket 4: Locked for 18 months with a 3 month dissolve delay.</li>
            <li>Basket 5: Locked for 24 months with a 3 month dissolve delay.</li>
        </ul>
        

        <p>Each Funded NFT holder will receive their $FPL within 5 baskets of equal neurons. The neurons will contain the following configuration:
        </p>
        <ul>
            <li>Basket 1: Unlocked with a dissolve delay of 30 days.</li>
            <li>Basket 2: Locked for 6 months with a 1 month dissolve delay.</li>
            <li>Basket 3: Locked for 12 months with a 1 month dissolve delay.</li>
            <li>Basket 4: Locked for 18 months with a 1 month dissolve delay.</li>
            <li>Basket 5: Locked for 24 months with a 1 month dissolve delay.</li>
        </ul>

        <p>Each SNS decentralisation swap participant will receive their $FPL within 5 baskets of equal neurons. The neurons will contain the following configuration:
        </p>
        <ul>
            <li>Basket 1: Unlocked with a dissolve delay of 30 days.</li>
            <li>Basket 2: Locked for 6 months with a 1 month dissolve delay.</li>
            <li>Basket 3: Locked for 12 months with a 1 month dissolve delay.</li>
            <li>Basket 4: Locked for 18 months with a 1 month dissolve delay.</li>
            <li>Basket 5: Locked for 24 months with a 1 month dissolve delay.</li>
        </ul>


        <h5>DAO Valuation</h5>

        <p>We have used the discounted cashflow method to value the DAO. The following assumptions have been made:</p>
        
        <ul>
            <li>We can grow to the size of our Web2 competitor over 8 years.</li>
            <li>Assumed 10% user conversion, each setting up a league at 1 ICP.</li>
            <li>Calculated as 10% of total user count in ICP.</li>
            <li>Estimated 5% user subscription rate at 5 ICP/month with 5% of this revenue going to the DAO.</li>
        </ul>
        
        <table>
            <tr>
                <th>Year</th>
                <th>1</th>
                <th>2</th>
                <th>3</th>
                <th>4</th>
                <th>5</th>
                <th>6</th>
                <th>7</th>
                <th>8</th>
            </tr>
            <tr>
                <th>Managers</th>
                <th>10,000</th>
                <th>50,000</th>
                <th>250,000</th>
                <th>1,000,000</th>
                <th>2,500,000</th>
                <th>5,000,000</th>
                <th>7,500,000</th>
                <th>10,000,000</th>
            </tr>
            <tr>
                <th>Private Leagues</th>
                <th>1,000</th>
                <th>5,000</th>
                <th>25,000</th>
                <th>100,000</th>
                <th>250,000</th>
                <th>500,000</th>
                <th>750,000</th>
                <th>1,000,000</th>
            </tr>
            <tr>
                <th>Merchandise</th>
                <th>1,600</th>
                <th>8,000</th>
                <th>40,000</th>
                <th>160,000</th>
                <th>400,000</th>
                <th>800,000</th>
                <th>1,200,000</th>
                <th>1,600,000</th>
            </tr>
            <tr>
                <th>Content Subscriptions</th>
                <th>1,600</th>
                <th>8,000</th>
                <th>40,000</th>
                <th>160,000</th>
                <th>400,000</th>
                <th>800,000</th>
                <th>1,200,000</th>
                <th>1,600,000</th>
            </tr>
        </table>


        <h5>SNS Decentralisation Sale Configuration</h5>

        <table>
            <tr>
                <th>Configuration</th>
                <th>Value</th>
            </tr>
            <tr>
                <th>The total number of FPL tokens to be sold.</th>
                <th>25,000,000 (25%)</th>
            </tr>
            <tr>
                <th>The maximum ICP to be raised.</th>
                <th>2,000,000</th>
            </tr>
            <tr>
                <th>The minimum ICP to be raised.</th>
                <th>1,000,000</th>
            </tr>
            <tr>
                <th>The minimum ICP to be raised (otherwise sale fails and ICP returned).</th>
                <th>1,000,000</th>
            </tr>
            <tr>
                <th>The ICP from the Community Fund.</th>
                <th>250,000</th>
            </tr>
            <tr>
                <th>Sale start date.</th>
                <th>1st March 2024</th>
            </tr>
            <tr>
                <th>Minimum number of sale participants.</th>
                <th>500</th>
            </tr>
            <tr>
                <th>Minimum ICP per buyer.</th>
                <th>10</th>
            </tr>
            <tr>
                <th>Minimum ICP per buyer.</th>
                <th>10</th>
            </tr>
            <tr>
                <th>Maximum ICP per buyer.</th>
                <th>150,000</th>
            </tr>
        </table>


        <h5>Mitigation against a 51% Attack</h5>

        <p>
        There is a danger that the OpenFPL SNS treasury could be the target of an attack. One possible scenario is for an attacker to buy a large proportion of the FPL tokens in the decentralisation sale and immediately increase the dissolve delay of all of their neurons to the maximum 4 year in an attempt to gain more than 50% of the SNS voting power. If successful they could force through a proposal to transfer the entire ICP and FPL treasury to themselves. The Community Fund actually provides a great deal of mitigation against this scenario because it limits the proportion of voting power an attacker would be able to acquire.

        </p>

        <p>The amount raised in the decentralisation will be used as follows</p>

        <ul>
            <li>85% will be staked in an 8 year neuron with the maturity interest paid to the ICPFA.</li>
            <li>5% will be paid directly to the ICPFA after the decentralisation sale.</li>
            <li>5% will be available for exchange liquidity to enable trading of the FPL token.</li>
            <li>5% will be held in reserve for cycles to run OpenFPL, likely to be unused as OpenFPL begins generating revenue.</li>
        </ul>

        <p>This treasury balance will be topped up with the DAO's revenue, with 50% being paid to neuron holders. Any excess balance can be utilised where the DAO sees fit.</p>
        
        <h5>Tokenomics</h5>

        <p>Each season, 2.5% of the total $FPL supply will be minted for DAO rewards. 
        There is no mechanism to automatically burn $FPL as we anticipate the user growth to be faster than the supply increase, 
        thus increasing the price of $FPL. However a proposal can always be made to burn $FPL if required. 
        If the DAO’s treasury is ever 60% or more of the total supply of $FPL, 
        it will be ICP FA policy to raise a proposal to burn 5% of the total supply from the DAO’s treasury.</p>

        <h5>ICP FA Overview</h5>

        <p>Managed by founder James Beadle, the ICP FA oversees the development, marketing, and management of OpenFPL. 
            The aim is to build a strong team to guide OpenFPL's growth and bring new users to the ICP blockchain. 
            Additionally, 25% of James' staked maturity earnings will contribute to the ICP FA Community Fund, supporting grassroots football projects.</p>

        <p>The ICPFA will receive 5% of the decentralisation sale along with the maturity interest from the staked neuron. These funds will be use for the following:</p>

        <ul>
            <li>The ongoing promotion and marketing of OpenFPL both online and offline.</li>
            <li>Hiring of a frontend and backend developer to assist the founder with the day to day development workload.</li>
            <li>Hiring of a UAT Test Engineer to ensure all ICPFA products are of the highest quality.</li>
            <li>Hiring of a Marketing Manager.</li>
        </ul>

        <p>Along with paying the founding team members:</p>

        <ul>
            <li>James Beadle - Founder, Lead Developer</li>
            <li>DfinityDesigner - Designer</li>
            <li>George - Community Manager</li>
            <li>ICP_Insider - Blockchain Promoter</li>
            <li>MadMaxIC - Gameplay Designer</li>
        </ul>

        <p>More details about the ICP FA and its members can be found at icpfa.org/team.</p>
        
    </div>
  );
};

export default Token;

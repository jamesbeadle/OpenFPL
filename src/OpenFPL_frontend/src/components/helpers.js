
export const toHexString = (byteArray) => {
    return Array.from(byteArray, function(byte) {
        return ('0' + (byte & 0xFF).toString(16)).slice(-2);
    }).join('').toUpperCase();
};

export const getAgeFromDOB = dob => {
    const birthDate = new Date(dob / 1000000);
    const ageDifMs = Date.now() - birthDate.getTime();
    const ageDate = new Date(ageDifMs);
    return Math.abs(ageDate.getUTCFullYear() - 1970);
};

export const formatDOB = dob => {
    const birthDate = new Date(dob / 1000000);
    const day = String(birthDate.getDate()).padStart(2, '0');
    const month = String(birthDate.getMonth() + 1).padStart(2, '0');
    const year = birthDate.getFullYear();
    return `${day}/${month}/${year}`;
};

export const msToTime = (duration) => {
    const seconds = Math.floor((duration / 1000) % 60);
    const minutes = Math.floor((duration / (1000 * 60)) % 60);
    const hours = Math.floor((duration / (1000 * 60 * 60)) % 24);
    const days = Math.floor(duration / (1000 * 60 * 60 * 24));

    return {
        days,
        hours,
        minutes,
        seconds
    };
};
    
export const nanoSecondsToMillis = (nanos) => {
    return Number(BigInt(nanos) / BigInt(1000000));
};
    
export const getTeamById = (teams, teamId) => {
    const team = teams.find(team => team.id === teamId);
    return team;
};
  
export const getPlayerById = (players, playerId) => {
    const player = players.find(player => player.id === playerId);
    return player;
};

export const groupFixturesByDate = (fixtures) => {
    return fixtures.reduce((acc, fixture) => {
        const date = (new Date(nanoSecondsToMillis(fixture.kickOff))).toDateString();
        if (!acc[date]) {
            acc[date] = [];
        }
        acc[date].push(fixture);
        return acc;
    }, {});
};

export const computeTimeLeft = (kickoff) => {
    const now = new Date().getTime();
    const distance = nanoSecondsToMillis(kickoff) - now;

    return {
        days: Math.floor(distance / (1000 * 60 * 60 * 24)),
        hours: Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)),
        minutes: Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60)),
        seconds: Math.floor((distance % (1000 * 60)) / 1000)
    };
};

export const dateToUnixNanoseconds = (dateString) => {
    const date = new Date(dateString);
    return date.getTime() * 1000000;
};

export const getPositionText = (position) => {
    switch(position){
        case 0:
            return 'GK';
        case 1:
            return 'DF';
        case 2:
            return 'MF';
        case 3:
            return 'FW';
    }
    return '';
};

export const getAvailableFormations = (playerCounts) => {
    const formations = ['3-4-3', '3-5-2', '4-3-3', '4-4-2', '4-5-1', '5-4-1', '5-3-2'];
    const available = [];
  
    formations.forEach(formation => {
      const [def, mid, fwd] = formation.split('-').map(Number);
      const minDef = Math.max(0, def - playerCounts[1]);
      const minMid = Math.max(0, mid - playerCounts[2]);
      const minFwd = Math.max(0, fwd - playerCounts[3]);
  
      if (minDef + minMid + minFwd <= 1 && playerCounts[0] === 1) {
        available.push(formation);
      }
    });
  
    return available;
  };

  export const isValidFormation = (formation, playerCounts) => {
    const [def, mid, fwd] = formation.split('-').map(Number);
    const gk = 1; // assuming 1 GK is always needed
  
    return (
      playerCounts[0] === gk &&
      playerCounts[1] >= def &&
      playerCounts[2] >= mid &&
      playerCounts[3] >= fwd
    );
  };
  
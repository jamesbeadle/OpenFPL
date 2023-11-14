export function formatUnixDateToReadable(unixNano: number) {
    const date = new Date(unixNano / 1000000);
    const options: Intl.DateTimeFormatOptions = {
        weekday: 'long', 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric'
      };
    
    return new Intl.DateTimeFormat('en-UK', options).format(date);
  }
  export function getCountdownTime(unixNano: number) {
    const targetDate = new Date(unixNano / 1000000);
    const now = new Date();
    const diff = targetDate.getTime() - now.getTime();
    
    if (diff <= 0) {
      return { days: 0, hours: 0, minutes: 0 };
    }
    
    const days = Math.floor(diff / (1000 * 60 * 60 * 24));
    const hours = Math.floor((diff / (1000 * 60 * 60)) % 24);
    const minutes = Math.floor((diff / (1000 * 60)) % 60);

    return { days, hours, minutes };
  }

  export function replacer(key: string, value: bigint) {
    if (typeof value === 'bigint') {
      return value.toString();
    } else {
      return value;
    }
  }
  
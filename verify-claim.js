const kp = require('ripple-keypairs');

const [addr, fecha, sig, pub] = process.argv.slice(2);
if (!addr || !fecha || !sig || !pub) {
  console.log('uso: node verify-claim.js <address> <YYYY-MM-DD> <firma> <clave_publica>');
  process.exit(1);
}

const msg = `402scope-claim ${addr} ${fecha}`;
const hex = Buffer.from(msg).toString('hex');

let derivada;
try { derivada = kp.deriveAddress(pub); }
catch (e) { console.log('RECHAZADO: clave publica invalida'); process.exit(1); }

// La firma prueba control de una cuenta; que sea la reclamada lo prueba
// que la direccion derive de esa misma clave publica.
if (derivada !== addr) {
  console.log('RECHAZADO: la clave publica corresponde a', derivada, 'no a', addr);
  process.exit(1);
}

let ok = false;
try { ok = kp.verify(hex, sig, pub); } catch (e) {}

console.log('mensaje  :', msg);
console.log('derivada :', derivada);
console.log(ok ? 'VERIFICADO' : 'RECHAZADO: la firma no valida');
process.exit(ok ? 0 : 1);

// This file can be replaced during build by using the `fileReplacements` array.
// `ng build` replaces `environment.ts` with `environment.prod.ts`.
// The list of file replacements can be found in `angular.json`.
  
import { initializeApp } from "firebase/app";  
import { getAnalytics } from "firebase/analytics";



export const environment = {
  production: false,

  firebase: {
  apiKey: "AIzaSyAMf4hZhPnwJMXdlfx0xWDgXMSfDOPVbVc",
  authDomain: "vitalog-app-36390.firebaseapp.com",
  projectId: "vitalog-app-36390",
  storageBucket: "vitalog-app-36390.firebasestorage.app",
  messagingSenderId: "724700704429",
  appId: "1:724700704429:web:e405a7590d74126d042024",
  measurementId: "G-0NB3BYE7BT"
}
};


/*
 * For easier debugging in development mode, you can import the following file
 * to ignore zone related error stack frames such as `zone.run`, `zoneDelegate.invokeTask`.
 *
 * This import should be commented out in production mode because it will have a negative impact
 * on performance if an error is thrown.
 */
// import 'zone.js/plugins/zone-error';  // Included with Angular CLI.

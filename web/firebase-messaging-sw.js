// /web/firebase-messaging-sw.js
importScripts('https://www.gstatic.com/firebasejs/10.12.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.12.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyDiABBzdjKTiRPBVlFnF5nPSUNUF8h4qW4',
  authDomain: 'interviewtask-6d696.firebaseapp.com',
  projectId: 'interviewtask-6d696',
  storageBucket: 'interviewtask-6d696.appspot.com',
  messagingSenderId: '724001120064',
  appId: '1:724001120064:web:57dfe30840b8dffdac24a5',
  measurementId: 'G-RSVK7305HM'
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(({ notification, data }) => {
  // Fallbacks in case the payload is data‑only:
  const title = notification?.title ?? 'New message';
  const options = {
    body: notification?.body ?? '',
    icon: '/icons/Icon-192.png',
    data                             // keep data for click handling
  };
  self.registration.showNotification(title, options);
});

self.addEventListener('notificationclick', event => {
  event.notification.close();
  // open the SPA route if you have one
  event.waitUntil(clients.openWindow('/#/property/' + (event.notification.data?.propertyId ?? '')));
});

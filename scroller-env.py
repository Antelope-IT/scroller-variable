#!/usr/bin/env python

import scrollphathd as sphd
import time
import os
import signal

class GracefulShutdown:
        shutdown_now = False
        def __init__(self):
                signal.signal(signal.SIGINT, self.exit_gracefully)
                signal.signal(signal.SIGTERM, self.exit_gracefully)

        def exit_gracefully(self, signum, frame):
                self.shutdown_now = True

if __name__ == '__main__':
        shutdown = GracefulShutdown()
        scrollMessage = os.environ['MESSAGE_TO_SCROLL']
        sphd.rotate(180)
        sphd.write_string(scrollMessage)
        while True:
                sphd.show()
                sphd.scroll(1)
                time.sleep(0.05)
                if shutdown.shutdown_now:
                        break

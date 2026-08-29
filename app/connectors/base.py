"""Processor-agnostic connector seam.

The recovery engine talks to processors through this thin interface, so any
switch can plug in without touching the diagnosis or gate layers."""


class PaymentConnector:
    name = "base"

    def fetch_failed_payments(self):
        raise NotImplementedError

    def retry_payment(self, external_payment_id):
        raise NotImplementedError

    def order_status(self, external_order_id):
        raise NotImplementedError
import logging
from ask_sdk_core.dispatch_components import AbstractRequestHandler
from ask_sdk_core.dispatch_components import AbstractExceptionHandler
from ask_sdk_core.skill_builder import SkillBuilder
from ask_sdk_core.utils import is_request_type, is_intent_name
from ask_sdk_core.handler_input import HandlerInput
from ask_sdk_model import Response
from ask_sdk_model.ui import SimpleCard

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


class LaunchRequestHandler(AbstractRequestHandler):
    def can_handle(self, handler_input):
        # type: (HandlerInput) -> bool
        return is_request_type("LaunchRequest")(handler_input)

    def handle(self, handler_input):
        # type: (HandlerInput) -> Response
        speech_text = "Welcome to the Elsevier Virtual Total Warehouse"

        handler_input.response_builder.speak(speech_text).set_card(
            SimpleCard("Elsevier", speech_text)
        ).set_should_end_session(False)
        return handler_input.response_builder.response


class HelpIntentHandler(AbstractRequestHandler):
    def can_handle(self, handler_input):
        # type: (HandlerInput) -> bool
        return is_intent_name("AMAZON.HelpIntent")(handler_input)

    def handle(self, handler_input):
        # type: (HandlerInput) -> Response
        speech_text = "You can ask me for total number of contents like articles, journals, issues, books and multimedia !"

        handler_input.response_builder.speak(speech_text).ask(speech_text).set_card(
            SimpleCard("Elsevier", speech_text)
        )
        return handler_input.response_builder.response


class ChildPlayAlexaIntentHandler(AbstractRequestHandler):
    api_url_base = "https://vtw.elsevier.com/search?query=type:"
    headers = {"Content-Type": "application/json", "Accept": "application/json"}

    def can_handle(self, handler_input):
        # type: (HandlerInput) -> bool
        return is_intent_name("ChildPlayAlexaIntent")(handler_input)

    def handle(self, handler_input):
        logger.info(handler_input)
        slots = handler_input.request_envelope.request.intent.slots
        content_value = slots["content"].value
        logger.info("Value passed is: " + content_value)
        speech_text = content_value + " is all good."
        handler_input.response_builder.speak(speech_text).set_card(
            SimpleCard("Elsevier", speech_text)
        ).set_should_end_session(False)
        return handler_input.response_builder.response


class CancelAndStopIntentHandler(AbstractRequestHandler):
    def can_handle(self, handler_input):
        # type: (HandlerInput) -> bool
        return is_intent_name("AMAZON.CancelIntent")(handler_input) or is_intent_name(
            "AMAZON.StopIntent"
        )(handler_input)

    def handle(self, handler_input):
        # type: (HandlerInput) -> Response
        speech_text = "Goodbye from VTW Development Team!"
        handler_input.response_builder.speak(speech_text).set_card(
            SimpleCard("Elsevier", speech_text)
        )
        return handler_input.response_builder.response


class SessionEndedRequestHandler(AbstractRequestHandler):
    def can_handle(self, handler_input):
        # type: (HandlerInput) -> bool
        return is_request_type("SessionEndedRequest")(handler_input)

    def handle(self, handler_input):
        # type: (HandlerInput) -> Response
        # any cleanup logic goes here
        return handler_input.response_builder.response


class AllExceptionHandler(AbstractExceptionHandler):
    def can_handle(self, handler_input, exception):
        # type: (HandlerInput, Exception) -> bool
        return True

    def handle(self, handler_input, exception):
        # type: (HandlerInput, Exception) -> Response
        # Log the exception in CloudWatch Logs
        logger.error(exception, exc_info=True)
        speech = "Sorry, I didn't get it. Can you please say it again!!"
        handler_input.response_builder.speak(speech).ask(speech)
        return handler_input.response_builder.response


sb = SkillBuilder()
sb.add_request_handler(LaunchRequestHandler())
sb.add_request_handler(HelpIntentHandler())
sb.add_request_handler(ChildPlayAlexaIntentHandler())
sb.add_request_handler(CancelAndStopIntentHandler())
sb.add_request_handler(SessionEndedRequestHandler())
sb.add_exception_handler(AllExceptionHandler())
lambda_handler = sb.lambda_handler()

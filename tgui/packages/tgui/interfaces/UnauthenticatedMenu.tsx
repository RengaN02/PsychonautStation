import { useEffect, useState } from 'react';
import { Box, Button, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

const MAX_TIMEOUT = 10800000; // 3 hours

type AuthOption = {
  name: string;
  url: string;
};

type MenuData = {
  auth_options: AuthOption[];
};

export const UnauthenticatedMenu = () => {
  const { act } = useBackend();

  const [banned, setIsBanned] = useState<string>();

  useEffect(() => {
    Byond.subscribeTo('banned', (payload) => setIsBanned(payload.reason));
  }, []);

  return (
    <Window theme="crtgreen" fitted scrollbars={false} width={305} height={168}>
      <Window.Content height="100%">
        <Stack vertical height="100%" justify="space-around" align="center">
          <Stack.Item>
            <Stack align="center">
              <Stack.Item>
                {banned ? <Banned reason={banned} /> : <Authentication />}
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const Authentication = () => {
  const { act, data } = useBackend<MenuData>();

  const { auth_options } = data;

  return (
    <Section title="Authenticate">
      <Stack vertical>
        <Stack.Item>
          You are not currently authenticated, so cannot log into the game.
        </Stack.Item>
        {auth_options.map((option) => (
          <Option key={option.name} option={option} />
        ))}
      </Stack>
    </Section>
  );
};

const Option = (props: { readonly option: AuthOption }) => {
  const { act } = useBackend<MenuData>();

  const { option } = props;

  return (
    <Stack.Item>
      <Stack align="center">
        <Stack.Item grow>
          <Button
            fluid
            onClick={() => {
              act('open_browser', { auth_option: option.name });
            }}
          >
            Click here to log in with {option.name}
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="up-right-from-square"
            onClick={() =>
              act('open_ext_browser', { auth_option: option.name })
            }
            tooltip="Open in Browser"
          />
        </Stack.Item>
      </Stack>
    </Stack.Item>
  );
};

const Banned = (props: { readonly reason: string }) => {
  const { reason } = props;
  return (
    <Section title="Authenticate">
      <Stack vertical>
        <Stack.Item>
          You are banned, and cannot currently log into the game.
        </Stack.Item>
        <Stack.Item>Reason: {reason}</Stack.Item>
        <Stack.Item>
          You will be automatically disconnected in ten seconds.
        </Stack.Item>
      </Stack>
    </Section>
  );
};

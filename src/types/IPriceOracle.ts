/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import {
  BaseContract,
  BigNumber,
  BytesLike,
  CallOverrides,
  PopulatedTransaction,
  Signer,
  utils,
} from "ethers";
import { FunctionFragment, Result } from "@ethersproject/abi";
import { Listener, Provider } from "@ethersproject/providers";
import { TypedEventFilter, TypedEvent, TypedListener, OnEvent } from "./common";

export interface IPriceOracleInterface extends utils.Interface {
  contractName: "IPriceOracle";
  functions: {
    "agetVirtualPrice(address)": FunctionFragment;
    "getVirtualPrice(address)": FunctionFragment;
  };

  encodeFunctionData(
    functionFragment: "agetVirtualPrice",
    values: [string]
  ): string;
  encodeFunctionData(
    functionFragment: "getVirtualPrice",
    values: [string]
  ): string;

  decodeFunctionResult(
    functionFragment: "agetVirtualPrice",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getVirtualPrice",
    data: BytesLike
  ): Result;

  events: {};
}

export interface IPriceOracle extends BaseContract {
  contractName: "IPriceOracle";
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: IPriceOracleInterface;

  queryFilter<TEvent extends TypedEvent>(
    event: TypedEventFilter<TEvent>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TEvent>>;

  listeners<TEvent extends TypedEvent>(
    eventFilter?: TypedEventFilter<TEvent>
  ): Array<TypedListener<TEvent>>;
  listeners(eventName?: string): Array<Listener>;
  removeAllListeners<TEvent extends TypedEvent>(
    eventFilter: TypedEventFilter<TEvent>
  ): this;
  removeAllListeners(eventName?: string): this;
  off: OnEvent<this>;
  on: OnEvent<this>;
  once: OnEvent<this>;
  removeListener: OnEvent<this>;

  functions: {
    agetVirtualPrice(
      token: string,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    getVirtualPrice(
      token: string,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;
  };

  agetVirtualPrice(
    token: string,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  getVirtualPrice(token: string, overrides?: CallOverrides): Promise<BigNumber>;

  callStatic: {
    agetVirtualPrice(
      token: string,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getVirtualPrice(
      token: string,
      overrides?: CallOverrides
    ): Promise<BigNumber>;
  };

  filters: {};

  estimateGas: {
    agetVirtualPrice(
      token: string,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getVirtualPrice(
      token: string,
      overrides?: CallOverrides
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    agetVirtualPrice(
      token: string,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getVirtualPrice(
      token: string,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;
  };
}
